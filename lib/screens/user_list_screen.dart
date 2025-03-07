import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/user_detail_screen.dart';

/// Displays a list of users with a responsive layout for phone and tablet.
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedUserIndex;

  @override
  void initState() {
    super.initState();
    // Fetch initial users after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
    // Add listener for pagination in phone layout
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Triggers pagination when scrolling to the bottom in phone layout.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<UserProvider>().fetchUsers();
    }
  }

  /// Generates an avatar URL based on the user's name.
  String _getAvatarUrl(String name) {
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&size=128';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(title: const Text('Users')),
          body: Consumer<UserProvider>(
            builder: (context, userProvider, _) =>
                _buildBody(userProvider, isTablet),
          ),
        );
      },
    );
  }

  /// Builds the main body based on the device type (tablet or phone).
  Widget _buildBody(UserProvider userProvider, bool isTablet) {
    if (userProvider.isLoading && userProvider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (userProvider.hasError) {
      return const Center(child: Text('Error loading users'));
    }

    return isTablet
        ? _buildTabletLayout(userProvider)
        : _buildPhoneLayout(userProvider);
  }

  /// Builds the tablet layout with a master-detail view.
  Widget _buildTabletLayout(UserProvider userProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel: User list
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 300,
            child: _buildUserList(userProvider, isTablet: true),
          ),
        ),
        // Divider between user list and detail view
        Container(
          width: 1, // Thin vertical line
          color: Colors.grey.withOpacity(0.3), // Subtle grey color
        ),
        // Right panel: Detail view
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _selectedUserIndex != null
                ? _buildDetailView(userProvider.users[_selectedUserIndex!])
                : const Center(child: Text('Select a user to view details')),
          ),
        ),
      ],
    );
  }

  /// Builds the phone layout with a grid view.
  Widget _buildPhoneLayout(UserProvider userProvider) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
            childAspectRatio: 3,
          ),
          itemCount: userProvider.users.length + (userProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == userProvider.users.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = userProvider.users[index];
            return Card(
              child: _buildUserTile(user, isTablet: false),
            );
          },
        );
      },
    );
  }

  /// Builds the user list for both tablet and phone layouts.
  Widget _buildUserList(UserProvider userProvider, {required bool isTablet}) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: userProvider.users.length + (userProvider.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == userProvider.users.length) {
          return VisibilityDetector(
            key: const Key('load-more-indicator'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction > 0 &&
                  userProvider.hasMore &&
                  !userProvider.isLoading) {
                print('Loading more users...');
                userProvider.fetchUsers();
              }
            },
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final user = userProvider.users[index];
        return isTablet
            ? _buildUserTile(user, isTablet: true, index: index)
            : Card(child: _buildUserTile(user, isTablet: false));
      },
    );
  }

  /// Builds a single user tile for the list.
  Widget _buildUserTile(User user, {required bool isTablet, int? index}) {
    final bool isSelected = isTablet && index == _selectedUserIndex;

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_getAvatarUrl(user.name)),
        radius: 24,
      ),
      title: Text(user.name),
      subtitle: Text(user.username),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.3),
      onTap: () {
        if (isTablet) {
          setState(() {
            _selectedUserIndex = index;
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
          );
        }
      },
    );
  }

  /// Builds the detailed view for a selected user (tablet layout).
  Widget _buildDetailView(User user) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name
                Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Avatar with border
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blueGrey.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_getAvatarUrl(user.name)),
                      radius: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Username with icon
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blueGrey, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.username,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Email with icon
                Row(
                  children: [
                    const Icon(Icons.email, color: Colors.blueGrey, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'More details coming soon...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
