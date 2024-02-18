
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:utsmobilewilbert/data/datasource/remote_datasource.dart';
import 'package:utsmobilewilbert/presentation/bloc/product_bloc.dart';
import 'package:utsmobilewilbert/presentation/pages/input.dart';
import 'package:utsmobilewilbert/utils/Utility.dart';

class PageList extends StatefulWidget {
  @override
  _PageListState createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBloc(remoteDataSource: RemoteDataSource())..add(LoadProduct()),
      child: Scaffold(
        body: ProductRefreshIndicator(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageInput(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ProductRefreshIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: UniqueKey(),
      onRefresh: () async {
        context.read<ProductBloc>().add(LoadProduct());
      },
      child: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back button once again to exit application'),
            ),
          );

          await Future.delayed(Duration(seconds: 2));

          SystemNavigator.pop();

          return false;
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          key: UniqueKey(),
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products;
              return MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: UniqueKey(),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Product"),
                              content: Text(
                                  "Are you sure want to delete this products?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        context
                            .read<ProductBloc>()
                            .add(DeleteProduct(products[index].id));
                      },
                      child: Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                products[index].imageUrl,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(products[index].name),
                              Text(products[index].category),
                              SizedBox(height: 8),
                              Text(
                                '${Utility.truncateDescription(products[index].description, 100)}...',
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle onTap
                          },
                        ),
                      ));
                },
              );
            } else if (state is ProductError) {
              return Center(
                child: Text(state.message),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
