import 'package:flutter/material.dart';
import 'package:ukk_2025/pelanggan/pelanggan.dart';
import 'package:ukk_2025/penjualan/penjualan.dart';
import 'package:ukk_2025/produk/produk.dart';

mydrawer(Map data, BuildContext context){return  Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 22, 136, 69), Color.fromARGB(255, 22, 136, 69), Color.fromARGB(255, 22, 136, 69),],
                  begin: Alignment.topLeft,
                ),
              ),
              accountName: Text(data['Username'] ?? 'Unknown User'),
              accountEmail: Text('(${data['Role']})'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 255, 252, 221),
                child: Text(
                  data['Username'].toString().toUpperCase()[0],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_search),
                title: Text('daftar pelanggan'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PelangganListPage(user: data,
                            )),
                  );
                },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_sharp),
                title: Text('daftar produk'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Produk(User: data,
                            )),
                  );
                },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_sharp),
                title: Text('penjualan'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Penjualan(login: data,
                            )),
                  );
                },
            )
          ],
        ),
      );}