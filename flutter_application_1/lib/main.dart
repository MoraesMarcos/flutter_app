import 'package:flutter/material.dart';
import 'comparison_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Shopping Assistant',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  void _searchProduct() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComparisonPage(productName: query),
        ),
      );
    }
  }

  final List<String> carouselImages = [
    'https://source.unsplash.com/800x400/?shopping',
    'https://source.unsplash.com/800x400/?electronics',
    'https://source.unsplash.com/800x400/?fashion'
  ];

  final List<Map<String, String>> featuredProducts = [
    {
      'title': 'Smartphone XYZ',
      'image': 'https://source.unsplash.com/300x300/?smartphone'
    },
    {
      'title': 'Laptop ABC',
      'image': 'https://source.unsplash.com/300x300/?laptop'
    },
    {
      'title': 'Headphones',
      'image': 'https://source.unsplash.com/300x300/?headphones'
    },
    {
      'title': 'Smartwatch',
      'image': 'https://source.unsplash.com/300x300/?smartwatch'
    },
    {
      'title': 'Camera Pro',
      'image': 'https://source.unsplash.com/300x300/?camera'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Shopping Assistant'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Lottie.asset('assets/shopping_animation.json',
                      height: 150,
                      errorBuilder: (context, error, stackTrace) =>
                          Container()),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Digite o nome do produto...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.blueAccent),
                    ),
                    onSubmitted: (value) => _searchProduct(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    onPressed: _searchProduct,
                    child: const Text(
                      'Comparar Preços',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(height: 200, autoPlay: true),
              items: carouselImages.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.grey)),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Destaques",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: featuredProducts
                          .map((product) => _buildHighlightCard(product))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                  "© 2024 AI Shopping Assistant - Todos os direitos reservados",
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard(Map<String, String> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 150,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(product['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product['title']!, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
