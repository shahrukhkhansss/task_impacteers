

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacteers_task/bloc/user_bloc.dart';
import 'package:impacteers_task/screens/user_detail_screen.dart';



class UserListScreen extends StatelessWidget {
  final TextEditingController _pageController = TextEditingController();

  UserListScreen({super.key});

  void _fetchUsers(BuildContext context) {
    final page = int.tryParse(_pageController.text) ?? 1;
    context.read<UserBloc>().add(FetchUsers(page));
  }

  void _navigateToUserDetails(BuildContext context, int userId) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: userBloc,
          child: UserDetailScreen(userId: userId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter page number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _fetchUsers(context),
                  child: const Text('Fetch Users'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserError) {
                  return Center(
                    child: Text('Error: ${state.error}',
                        style: const TextStyle(color: Colors.red)),
                  );
                } else if (state is UserLoaded) {
                  final userList = state.users;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(user['avatar']),
                          ),
                          title: Text(
                            '${user['first_name']} ${user['last_name']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          subtitle: Text(
                            user['email'],
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          onTap: () => _navigateToUserDetails(context, user['id']),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No users found',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}