import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const DavStarApp(),
    ),
  );
}

class DavStarApp extends StatelessWidget {
  const DavStarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAVSTar',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.deepPurple),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
