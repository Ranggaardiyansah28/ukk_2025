// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:ukk_2025/produk/produk.dart';
// import 'package:ukk_2025/pelanggan/pelanggan.dart';

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const Center(child: Text('Halaman Beranda', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Halaman Profil', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Halaman Pengaturan', style: TextStyle(fontSize: 24))),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Beranda'),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: const Text('User Name'),
//               accountEmail: const Text('user@example.com'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
//               ),
//               decoration: BoxDecoration(color: Colors.blueAccent),
//             ),
//             ListTile(
//               leading: Icon(Icons.person, color: Colors.blueAccent),
//               title: const Text('Profile'),
//               onTap: () {
//                 Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => Produk(User: {},))
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings, color: Colors.blueAccent),
//               title: const Text('Pengaturan'),
//               onTap: () {
//                 Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => Produk(User: {},))
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blueAccent,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
