import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart' as provider; // Use alias for UserProvider
import '../screens/user_detail_screen.dart'; 


class UserListScreen extends StatefulWidget {
  final bool showAppBar;

  const UserListScreen({super.key, this.showAppBar = true});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedUserIndex;
  bool _hasScrolled = false;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<provider.UserProvider>();
      if (userProvider.users.isEmpty) {
        userProvider.fetchUsers();
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasScrolled && _scrollController.position.pixels > 0) {
      setState(() {
        _hasScrolled = true;
      });
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final userProvider = context.read<provider.UserProvider>();
      if (userProvider.users.isNotEmpty &&
          userProvider.hasMore &&
          !userProvider.isLoading &&
          !_isFetchingMore) {
        print(
            'Fetching more users via scroll, page: ${userProvider.currentPage + 1}...');
        setState(() {
          _isFetchingMore = true;
        });
        userProvider.fetchUsers().then((_) {
          if (mounted) {
            setState(() {
              _isFetchingMore = false;
            });
          }
        });
      }
    }
  }

  String _getAvatarUrl(int userId) {
    return 'https://picsum.photos/id/$userId/200/200';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        final bool isTablet = constraints.maxWidth > 600 && !isPortrait;

        return Scaffold(
          appBar: widget.showAppBar ? AppBar(title: const Text('Users')) : null,
          body: Consumer<provider.UserProvider>(
            builder: (context, userProvider, _) =>
                _buildBody(userProvider, isTablet),
          ),
        );
      },
    );
  }

  Widget _buildBody(provider.UserProvider userProvider, bool isTablet) {
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

  Widget _buildTabletLayout(provider.UserProvider userProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 300,
            child: _buildUserList(userProvider, isTablet: true),
          ),
        ),
        Container(width: 1, color: Colors.grey.withOpacity(0.3)),
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

  Widget _buildPhoneLayout(provider.UserProvider userProvider) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _onScroll();
        }
        return false;
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
              childAspectRatio: 1.5,
            ),
            itemCount: userProvider.users.length +
                (_hasScrolled && _isFetchingMore && userProvider.hasMore
                    ? 1
                    : 0),
            itemBuilder: (context, index) {
              if (index == userProvider.users.length &&
                  _hasScrolled &&
                  _isFetchingMore &&
                  userProvider.hasMore) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = userProvider.users[index];
              return Card(child: _buildUserTile(user, isTablet: false));
            },
          );
        },
      ),
    );
  }

  Widget _buildUserList(provider.UserProvider userProvider,
      {required bool isTablet}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _onScroll();
        }
        return false;
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: userProvider.users.length +
            (_hasScrolled && _isFetchingMore && userProvider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == userProvider.users.length &&
              _hasScrolled &&
              _isFetchingMore &&
              userProvider.hasMore) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = userProvider.users[index];
          return isTablet
              ? _buildUserTile(user, isTablet: true, index: index)
              : Card(child: _buildUserTile(user, isTablet: false));
        },
      ),
    );
  }

  Widget _buildUserTile(User user, {required bool isTablet, int? index}) {
    final bool isSelected = isTablet && index == _selectedUserIndex;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_getAvatarUrl(user.id)),
        radius: 24,
      ),
      title: Text(user.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.username),
          const SizedBox(height: 4),
          Text(user.email,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            '${user.address.street}, ${user.address.suite}, ${user.address.city}, ${user.address.zipcode}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.3),
      onTap: () {
        if (isTablet) {
          setState(() => _selectedUserIndex = index);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
          );
        }
      },
    );
  }

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
                Center(
                    child: Text(user.name,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey))),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.blueGrey.withOpacity(0.3), width: 3),
                    ),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(_getAvatarUrl(user.id)),
                        radius: 60),
                  ),
                ),
                const SizedBox(height: 30),
                Row(children: [
                  const Icon(Icons.person, color: Colors.blueGrey, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Username',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(user.username,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87))
                      ]))
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  const Icon(Icons.email, color: Colors.blueGrey, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Email',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(user.email,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87))
                      ]))
                ]),
                const SizedBox(height: 20),
                Row(children: [
                  const Icon(Icons.location_on,
                      color: Colors.blueGrey, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text('Address',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                            '${user.address.street}, ${user.address.suite}, ${user.address.city}, ${user.address.zipcode}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87))
                      ]))
                ]),
                const SizedBox(height: 20),
                Divider(color: Colors.grey.withOpacity(0.3), thickness: 1),
                const SizedBox(height: 10),
                const Center(
                    child: Text('More details coming soon...',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
