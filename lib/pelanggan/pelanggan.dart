import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/drawer.dart';
import 'package:ukk_2025/pelanggan/editpelanggan.dart';
import 'package:ukk_2025/pelanggan/tambahpelanggan.dart';

class PelangganListPage extends StatefulWidget {
  final Map user;
  const PelangganListPage({super.key, required this.user});

  @override
  State<PelangganListPage> createState() => _PelangganListPageState();
}

class _PelangganListPageState extends State<PelangganListPage> {
  List<Map<String, dynamic>> Pelanggan = [];
  List<Map<String, dynamic>> User = [];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> fetch() async {
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();

      setState(() {
        Pelanggan = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> tambahpelanggan(
      String NamaPelanggan, String Alamat, String NomorTelepon) async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').insert([
        {
          'NamaPelanggan': NamaPelanggan,
          'Alamat': Alamat,
          'NomorTelepon': NomorTelepon
        }
      ]);
      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi berhasil.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi tidak berhasil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $Error')),
      );
    }
  }

  Future<void> hapuspelanggan(int PelangganId) async {
    try {
      final response = await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', PelangganId);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk berhasil dihapus')),
        );
        fetch();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFAF3E0),
        drawer:mydrawer(widget.user, context),
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: "Cari Pelanggan",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color.fromARGB(255, 149, 196, 152),
                filled: true),
          ),
          backgroundColor: Color.fromARGB(255, 22, 136, 69),
          foregroundColor:Color.fromARGB(255, 149, 196, 152),
          actions: [
            IconButton(
              onPressed: fetch,
              icon: const Icon(Icons.refresh),
              color: Color(0xFFFAF3E0),
            ),
          ],
        ),
        body: Pelanggan.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: Pelanggan.where((pelanggan) {
                  final nama = pelanggan['NamaPelanggan']?.toLowerCase() ?? '';
                  final alamat = pelanggan['Alamat']?.toLowerCase() ?? '';
                  final nomor = pelanggan['NomorTelepon']?.toLowerCase() ?? '';
                  return nama.contains(_searchQuery) ||
                      alamat.contains(_searchQuery) ||
                      nomor.contains(_searchQuery);
                }).length,
                itemBuilder: (context, index) {
                  final filteredPelanggan = Pelanggan.where((pelanggan) {
                    final nama =
                        pelanggan['NamaPelanggan']?.toLowerCase() ?? '';
                    final alamat = pelanggan['Alamat']?.toLowerCase() ?? '';
                    final nomor =
                        pelanggan['NomorTelepon']?.toLowerCase() ?? '';
                    return nama.contains(_searchQuery) ||
                        alamat.contains(_searchQuery) ||
                        nomor.startsWith(_searchQuery);
                  }).toList();

                  final pelanggan = filteredPelanggan[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 22, 136, 69),
                          width: 1), 
                    ),
                    child: ListTile(
                      title: Text(
                        pelanggan['NamaPelanggan'] ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pelanggan['Alamat'] ?? 'No Alamat',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            pelanggan['NomorTelepon'] ?? 'No Nomor',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Editpelanggan(
                                                pelanggan: pelanggan)));
                                    if (result == 'success') {
                                      fetch();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 22, 136, 69),
                                  )),
                                IconButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus produk ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                fetch();
                                                Navigator.pop(context, true);
                                              },
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirm == true) {
                                      hapuspelanggan(pelanggan['PelangganID']);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                        ],
                      ),
                    ),
                  );
                }),
        floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _AddPelanggan(context);
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Color.fromARGB(255, 22, 136, 69),
              )
            );
  }

  void _AddPelanggan(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Registerpelanggan(
            onAddpelanggan: (NamaPelanggan, Alamat, NomorTelepon) {
          tambahpelanggan(NamaPelanggan, Alamat, NomorTelepon);
          Navigator.pop(context, true);
        });
      },
    );
    if (result == true) {
      fetch();
    }
  }
}