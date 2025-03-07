// lib/screens/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.grey[500],
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) {
          if (provider.users.isEmpty && provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          final isTablet = MediaQuery.of(context).size.width > 600;

          return isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(child: _buildUserList(provider, context)),
                          _buildLoadMoreButton(provider),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: _selectedUser != null
                                  ? UserDetailScreen(
                                      user: _selectedUser!, isEmbedded: true)
                                  : Center(
                                      child: Text(
                                          'Select a user to see details',
                                          style: TextStyle(
                                              color: Colors.grey[600]))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: _buildUserList(provider, context),
                    ),
                    _buildLoadMoreButton(provider),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildUserList(UserProvider provider, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: provider.users.length,
      itemBuilder: (context, index) {
        final user = provider.users[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.grey[200],
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://picsum.photos/50'),
              radius: 25,
              backgroundColor: Colors.grey[300],
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('Image load error: $exception');
              },
            ),
            title: Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'ID: ${user.id} | @${user.username}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            onTap: () {
              if (MediaQuery.of(context).size.width <= 600) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDetailScreen(user: user)),
                );
              } else {
                setState(() {
                  _selectedUser = user;
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreButton(UserProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: provider.hasMore
          ? ElevatedButton(
              onPressed:
                  provider.isLoading ? null : () => provider.fetchUsers(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[500],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: provider.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Load More',
                      style: TextStyle(fontSize: 16),
                    ),
            )
          : Text(
              'No more users',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
    );
  }
}
