import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EditProduk extends StatefulWidget {
  final Map<String, dynamic> barang;

  const EditProduk({super.key, required this.barang});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _namaprodukController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;

  @override
  void initState() {
    super.initState();
    _namaprodukController = TextEditingController(text: widget.barang['NamaProduk']);
    _hargaController = TextEditingController(text: widget.barang['Harga'].toString());
    _stokController = TextEditingController(text: widget.barang['Stok'].toString());
  }

  Future<void> updateBarang(int ProdukID, String NamaProduk, String Harga, String Stok) async {
    try {
      await Supabase.instance.client.from('produk').update({
        'NamaProduk': NamaProduk,
        'Harga': int.parse(Harga),
        'Stok': int.parse(Stok),
      }).eq('ProdukID', ProdukID);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF003366),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Produk', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaprodukController,
                decoration: const InputDecoration(labelText: 'Nama Produk', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stokController,
                decoration: const InputDecoration(labelText: 'Stok', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Stok tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState?.validate() ?? false) {
                    updateBarang(
                      widget.barang['ProdukID'],
                      _namaprodukController.text,
                      _hargaController.text,
                      _stokController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 17, 144, 69)),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
