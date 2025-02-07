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
  String _selectedSort = 'Preço: Menor para Maior';

  @override
  void initState() {
    super.initState();
    _fetchProductPrices();
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
      appBar: AppBar(title: const Text('Comparação de Preços')),
      body: Column(
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
                  items: ['Preço: Menor para Maior', 'Preço: Maior para Menor']
                      .map((String value) {
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
          Expanded(
            child: _productList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _productList.length,
                    itemBuilder: (context, index) {
                      final product = _productList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
