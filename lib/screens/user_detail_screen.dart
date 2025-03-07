// lib/screens/user_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;
  final bool isEmbedded;

  const UserDetailScreen(
      {super.key, required this.user, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
            16.0, 8.0, 16.0, 16.0), // Reduced top padding from 16.0 to 8.0
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                        backgroundImage:
                            NetworkImage('https://picsum.photos/50'),
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint('Image load error: $exception');
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'ID:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.id.toString(),
                      style: const TextStyle(color: Colors.black87)),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Name:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.name,
                      style:
                          const TextStyle(fontSize: 24, color: Colors.black87)),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Username:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.username,
                      style: const TextStyle(color: Colors.grey)),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Email:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.email,
                      style: const TextStyle(color: Colors.grey)),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Phone:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.phone,
                      style: const TextStyle(color: Colors.grey)),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Website:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  subtitle: Text(user.website,
                      style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // If embedded (tablet layout), return just the content
    if (isEmbedded) {
      return content;
    }

    // If standalone (phone layout), wrap in a Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.grey[400],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[400]!, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: content,
    );
  }
}
