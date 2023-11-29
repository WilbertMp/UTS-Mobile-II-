// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_final_fields, sized_box_for_whitespace, unnecessary_string_interpolations, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../model/item.dart';
import '../service/item.dart';
import 'input.dart';
import 'list.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PageList(),
    PageProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 100,
          height: 50,
          child: Image.asset('assets/logo.png', fit: BoxFit.cover),
        ),
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.grey,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product>? products;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _loadData();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    List<Product> loadedProducts = await StorageService.getProducts();
    setState(() {
      products = loadedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (products!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum ada data pada aplikasi ini.',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageInput(),
                  ),
                );
              },
              child: Text('Klik Disini untuk Isi Data'),
            ),
          ],
        ),
      );
    }

    Map<String, List<Product>> groupedProducts =
        StorageService.groupProductsByCategory(products ?? []);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200.0,
            margin: EdgeInsets.all(24),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {});
              },
              itemCount: products!.length > 3 ? 3 : products!.length,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  'assets/logo.png',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Selamat datang di Chemicy App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Cari aksesoris gaming yang anda butuhkan di aplikasi kami.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: groupedProducts.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String category = groupedProducts.keys.elementAt(index);
                List<Product> categoryProducts = groupedProducts[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '$category',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150.0,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: categoryProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GridItem(product: categoryProducts[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Product product;

  GridItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            product.imageUrl,
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          Text(
            product.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
