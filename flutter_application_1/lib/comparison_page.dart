import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ComparisonPage extends StatefulWidget {
  final String productName;

  const ComparisonPage({super.key, required this.productName});

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  List<dynamic> _productList = [];
  List<dynamic> _topSellingProducts = [];
  String _selectedSort = 'Preço: Menor para Maior';

  @override
  void initState() {
    super.initState();
    _fetchProductPrices();
    _fetchTopSellingProducts();
  }

  Future<void> _fetchProductPrices() async {
    final url = Uri.parse(
        'https://api.mercadolibre.com/sites/MLB/search?q=${widget.productName}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _productList = json.decode(response.body)['results'];
        _sortProducts(_selectedSort);
      });
    }
  }

  Future<void> _fetchTopSellingProducts() async {
    final url = Uri.parse(
        'https://api.mercadolibre.com/sites/MLB/search?q=${widget.productName}&sort=sold_quantity_desc');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _topSellingProducts =
            json.decode(response.body)['results'].take(5).toList();
      });
    }
  }

  void _sortProducts(String sortType) {
    setState(() {
      _selectedSort = sortType;
      if (sortType == 'Preço: Menor para Maior') {
        _productList.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (sortType == 'Preço: Maior para Menor') {
        _productList.sort((a, b) => b['price'].compareTo(a['price']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação de Preços'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ordenar por:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedSort,
                    items: [
                      'Preço: Menor para Maior',
                      'Preço: Maior para Menor'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _sortProducts(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Mais Vendidos",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            _topSellingProducts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _topSellingProducts.length,
                      itemBuilder: (context, index) {
                        final product = _topSellingProducts[index];
                        return _buildTopSellingCard(product);
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            const Text("Resultados da Pesquisa",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            _productList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _productList.length,
                    itemBuilder: (context, index) {
                      final product = _productList[index];
                      return _buildProductCard(product);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingCard(dynamic product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product['thumbnail'],
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              launchUrl(Uri.parse(product['permalink']));
            },
            child: const Text('Ver Oferta'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            product['thumbnail'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          product['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'R\$ ${product['price']}',
          style: const TextStyle(fontSize: 16, color: Colors.green),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            launchUrl(Uri.parse(product['permalink']));
          },
          child: const Text('Ver Oferta'),
        ),
      ),
    );
  }
}
