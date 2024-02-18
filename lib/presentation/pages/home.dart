import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utsmobilewilbert/data/datasource/remote_datasource.dart';
import 'package:utsmobilewilbert/data/model/product.dart';
import 'package:utsmobilewilbert/data/services/item.dart';
import 'package:utsmobilewilbert/presentation/pages/list.dart';
import 'package:utsmobilewilbert/presentation/pages/profile.dart';
import 'package:utsmobilewilbert/presentation/bloc/product_bloc.dart';

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
    return BlocProvider(
      create: (context) =>
          ProductBloc(remoteDataSource: RemoteDataSource())..add(LoadProduct()),
      child: Scaffold(
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
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProductLoaded) {
          List<Product> products = state.products;
          Map<String, List<Product>> groupedProducts =
              StorageService.groupProductsByCategory(products);
          return RefreshIndicator(
              child: _buildHomePage(groupedProducts),
              onRefresh: () async {
                context.read<ProductBloc>().add(LoadProduct());
              });
        } else if (state is ProductError) {
          return Center(
            child: Text('Failed to load products'),
          );
        } else {
          return Center(
            child: Text('Unknown state'),
          );
        }
      },
    );
  }

  Widget _buildHomePage(Map<String, List<Product>> groupedProducts) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200.0,
            margin: EdgeInsets.all(24),
            child: Placeholder(),
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
