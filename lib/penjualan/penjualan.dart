import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ukk_2025/drawer.dart';
import 'package:ukk_2025/penjualan/struk.dart';
import 'package:ukk_2025/penjualan/tambahpenjualan.dart';


class Penjualan extends StatefulWidget {
  final Map login;
  const Penjualan({super.key, required this.login});


  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> with TickerProviderStateMixin {
  TabController? myTabControl;
  List penjualan = [];
  List detailPenjualan = [];
  List produk=[];
  List pelanggan=[];
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  void fetchSales() async {
    var myProduk = await Supabase.instance.client
        .from('produk')
        .select()
        .order('ProdukID', ascending: true);
    var myCustomer = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .order('PelangganID', ascending: true);

    var responseSales = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*), detailpenjualan(*, produk(*))');
    var responseSalesDetail = await Supabase.instance.client
        .from('detailpenjualan')
        .select('*, penjualan(*, pelanggan(*)), produk(*)');
    
    setState(() {
      penjualan = responseSales;
      detailPenjualan = responseSalesDetail;
      produk = myProduk;
      pelanggan = myCustomer;
    });
  }

  @override
  void initState() {
    
    super.initState();
    fetchSales();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    myTabControl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
  
    super.dispose();
    myTabControl?.dispose();
  }

  generateSales() {
    var filteredSales = penjualan.where((sale) {
    var tanggalPenjualan = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(sale['TanggalPenjualan'])
    );
    return _searchQuery.isEmpty || tanggalPenjualan.contains(_searchQuery);
  }).toList();
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(filteredSales.length, (index) {
          var tanggalPenjualan = DateFormat(
            'dd MMMM yyyy',
          ).format(DateTime.parse(filteredSales[index]['TanggalPenjualan']));
          return Card(
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(penjualan[index]['PelangganID'] == null
                                ? 'Pelanggan tidak terdaftar'
                                : '${penjualan[index]['pelanggan']['NamaPelanggan']} (${penjualan[index]['pelanggan']['NomorTelepon']})')
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.rupiahSign,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text('${penjualan[index]['TotalHarga']}')
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.calendar,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text('${tanggalPenjualan}')
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Struk( penjualan: penjualan[index])));
                    }, icon:Icon(Icons.print))
                  ],
                ),
              ));
        })
      ],
    );
  }

  generateSalesDetail() {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 2,
      children: [
        ...List.generate(detailPenjualan.length, (index) {
          var tanggalPenjualan = DateFormat('dd MMMM yyyy').format(
              DateTime.parse(
                  detailPenjualan[index]['penjualan']['TanggalPenjualan']));
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(
                      width: 10,
                    ),
                    Text(detailPenjualan[index]['penjualan']['PelangganID'] ==
                            null
                        ? 'Pelanggan tidak terdaftar'
                        : '${detailPenjualan[index]['penjualan']['pelanggan']['NamaPelanggan']} (${detailPenjualan[index]['penjualan']['pelanggan']['NomorTelepon']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.cartShopping),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        '${detailPenjualan[index]['produk']['NamaProduk']} (${detailPenjualan[index]['JumlahProduk']})'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.rupiahSign),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${detailPenjualan[index]['Subtotal']}'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${tanggalPenjualan}'),
                  ],
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   const Color(0xFFFAF3E0),
      appBar: AppBar(
        // ),
        centerTitle: true,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: "Cari Riwayat Penjualan",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 22, 136, 69),
        actions: [
          IconButton(
            onPressed: fetchSales,
            icon: const Icon(Icons.refresh),
            color: Color(0xFFFAF3E0),
          ),
        ],
      ),
      drawer: mydrawer(widget.login, context),
      body: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Sales'),
              Tab(text: 'Sales Detail'),
            ],
            controller: myTabControl,
          ),
          Expanded(
            child: TabBarView(
              children: [
                penjualan.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : generateSales(),
                detailPenjualan.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : generateSalesDetail()
              ],
              controller: myTabControl,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(produk);
          var jual = await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => SalesPage( produk: produk,pelanggan: pelanggan,
                            login: widget.login,
                          ))
          );
          if (jual == 'success') {
            fetchSales();
          }
        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: const Color.fromARGB(255, 22, 136, 69),
      )
    );
  }
}