import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/screens/splash_screen.dart';
import 'bloc/task_bloc.dart';
import 'bloc/task_event.dart';
import 'db/db_service.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => TaskBloc(DatabaseHelper.instance)..add(LoadTasks()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
