import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacteers_task/api/api_service.dart';
import 'package:impacteers_task/bloc/user_bloc.dart';
import 'package:impacteers_task/screens/user_list_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => UserBloc(apiService),
        child: UserListScreen(),
      ),
    );
  }
}

