import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Halaman Beranda', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Halaman Profil', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Halaman Pengaturan', style: TextStyle(fontSize: 24))),
  
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}