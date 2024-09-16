import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urunler_json_model_api_cekme/models/urunler_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UrunlerModel? _veriler;
  List<Urun> _urunler = [];

  void _loadData() async {
    final dataString = await rootBundle.loadString('assets/files/data.json');
    final dataJson = jsonDecode(dataString);
    //decode->datayı json'a //encode-->json u dataya

    _veriler = UrunlerModel.fromJson(dataJson);
    _urunler = _veriler!.urunler;
    setState(() {});
  }

  void _filterData(int id) {
    //id ile filtreleme
    _urunler = _veriler!.urunler
        .where((verilerEleman) => verilerEleman.kategori == id)
        .toList();

    setState(() {});
  }

  void _resetFilter() {
    _urunler = _veriler!.urunler;
    setState(() {});
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _veriler == null
            ? const Text('Yükleniyor')
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: _resetFilter,
                    child: const Text('Tüm Ürünler'),
                  ),
                  _kategorilerView(),
                  Expanded(
                    // Expanded ekleyerek listeyi ekrana sığdırıyoruz
                    child: _urunlerView(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _urunlerView() {
    return ListView.separated(
      itemCount: _urunler.length,
      itemBuilder: (context, index) {
        final Urun urun = _urunler[index];
        return ListTile(
          leading: Image.network(urun.resim,
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text(urun.isim),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 10),
    );
  }

  Widget _kategorilerView() {
    return SingleChildScrollView(
      // Kategoriler için kaydırılabilir bir yapı
      scrollDirection: Axis.horizontal, // Yatay kaydırma
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _veriler!.kategoriler.length,
          (index) {
            final kategori = _veriler!.kategoriler[index];
            return GestureDetector(
              onTap: () => _filterData(kategori.id),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(kategori.isim),
              ),
            );
          },
        ),
      ),
    );
  }
}
