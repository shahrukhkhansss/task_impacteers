import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacteers_task/bloc/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class UserDetailScreen extends StatelessWidget {
  final int userId;

  UserDetailScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Fetch user details when the screen is built
    context.read<UserBloc>().add(FetchUserDetails(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(
              child: Text('Error: ${state.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          } else if (state is UserDetailLoaded) {
            final user = state.userDetails['data'];
            final support = state.userDetails['support'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: NetworkImage(user['avatar']),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    '${user['first_name']} ${user['last_name']}',
                    style: const TextStyle(
                        fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    user['email'],
                    style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24.0),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 16.0),
                  if (support != null) ...[
                    const Text(
                      'Support Information',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Support URL:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4.0),
                    GestureDetector(
                      onTap: () {
                        if (support['url'] != null) {
                          _launchURL(support['url']);
                        }
                      },
                      child: Text(
                        support['url'] ?? 'No URL available',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Support Text:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      support['text'] ?? 'No support text available',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('User not found',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }
        },
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}