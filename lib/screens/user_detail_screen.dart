import 'package:flutter/material.dart';
import '../models/user.dart';
import 'user_list_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  String _getAvatarUrl(int userId) {
    return 'https://picsum.photos/id/$userId/200/200';
  }

  Widget _buildDetailContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      backgroundImage: NetworkImage(_getAvatarUrl(user.id)),
                      radius: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.blueGrey,
                      size: 28,
                    ),
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
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: Colors.blueGrey,
                      size: 28,
                    ),
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
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.blueGrey,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.address.street}, ${user.address.suite}, ${user.address.city}, ${user.address.zipcode}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.grey.withOpacity(0.3),
                  thickness: 1,
                ),
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
        final bool isTablet = constraints.maxWidth > 600 && !isPortrait;

        if (isTablet) {
          // Tablet mode: Embed UserListScreen without its AppBar
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 300,
                    child: UserListScreen(showAppBar: false), // Hide AppBar
                  ),
                ),
                Container(width: 1, color: Colors.grey.withOpacity(0.3)),
                Expanded(
                  flex: 2,
                  child: _buildDetailContent(context),
                ),
              ],
            ),
          );
        } else {
          // Phone mode: Show detail screen with navigation
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: _buildDetailContent(context),
          );
        }
      },
    );
  }
}