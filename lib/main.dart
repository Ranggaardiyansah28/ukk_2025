import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'loginpage.dart';
import 'berandapage.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://sexaxgznypcqkraqmjwg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNleGF4Z3pueXBjcWtyYXFtandnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTU0MzUsImV4cCI6MjA1NDk5MTQzNX0.VNQKrwFZkobJar9QKvgQ7UVUUs_sqK3ZoYICb7r8VuA',

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Supabase',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        
      ),
      home: const LoginPage(

      ),
    );
  }
}
