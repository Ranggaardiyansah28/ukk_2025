import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/drawer.dart';
import 'package:ukk_2025/produk/editproduk.dart';
import 'package:ukk_2025/produk/tambahproduk.dart';

class Produk extends StatefulWidget {
  final Map User;
  const Produk({super.key, required this.User});

  @override
  State<Produk> createState() => _produkstate();
}

class _produkstate extends State<Produk> {
  List<Map<String, dynamic>> Barang = [];
  final TextEditingController _searchController = TextEditingController();
  var selectedIndex = 0;
  var _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    initializeData();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        initializeData();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> initializeData() async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select()
          .order("ProdukID", ascending: true);
      setState(() {
        Barang = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> tambah(String NamaProduk, String Harga, String Stok) async {
    try {
      await Supabase.instance.client.from('produk').insert([
        {'NamaProduk': NamaProduk, 'Harga': Harga, 'Stok': Stok}
      ]);
      initializeData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error menambah produk: $e')),
      );
    }
  }

  Future<void> hapusBarang(int ProdukId) async {
    try {
      await Supabase.instance.client
          .from('produk')
          .delete()
          .eq('ProdukID', ProdukId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus')),
      );
      initializeData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  GridView card([String? jenis]) {
    List<Map<String, dynamic>> filteredBarang = jenis == null
        ? Barang
        : Barang.where((barang) => barang['Jenis'] == jenis).toList();

    return GridView.builder(
      itemCount: filteredBarang.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3.2,
      ),
      itemBuilder: (context, index) {
        var barang = filteredBarang[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: LayoutBuilder(
            builder: (context, constraint) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang['NamaProduk'],
                          style: TextStyle(fontSize: constraint.maxHeight / 4),
                        ),
                        Text(
                          'RP ${barang['Harga']}',
                          style: TextStyle(fontSize: constraint.maxHeight / 6),
                        ),
                        Text(
                          'Stok ${barang['Stok']}',
                          style: TextStyle(fontSize: constraint.maxHeight / 6),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProduk(
                                          barang: barang,
                                        )));
                          },
                          icon: Icon(
                            size: constraint.maxHeight / 4,
                            Icons.edit,
                            color: Color.fromARGB(255, 22, 136, 69),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                      'Apakah Anda yakin ingin menghapus produk ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        hapusBarang(barang['ProdukID']);
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            size: constraint.maxHeight / 4,
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 149, 196, 152),
      drawer:mydrawer(widget.User, context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 22, 136, 69),
        foregroundColor: Color.fromARGB(255, 149, 196, 152),
        elevation: 1,
        title: Text('produk')
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: [
                card(),
                card('makanan'),
                card('minuman'),
                card('dissert'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 22, 136, 69),
      ),
    );
  }

  _showAddDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Tambahproduk(onAddBarang: (NamaProduk, Harga, Stok) {

        });
      },
    );
    if (result == true) {
      initializeData();
    }
  }
}
