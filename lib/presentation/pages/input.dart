
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utsmobilewilbert/data/model/product.dart';
import 'package:utsmobilewilbert/presentation/bloc/product_bloc.dart';
import 'package:utsmobilewilbert/presentation/pages/home.dart';

class PageInput extends StatefulWidget {
  final Product? productToEdit;
  final bool isEditing;

  PageInput({Key? key, this.productToEdit, this.isEditing = false})
      : super(key: key);

  @override
  _PageInputState createState() => _PageInputState();
}

class _PageInputState extends State<PageInput> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.productToEdit != null) {
      nameController.text = widget.productToEdit!.name;
      descriptionController.text = widget.productToEdit!.description;
      imageUrlController.text = widget.productToEdit!.imageUrl;
      categoryController.text = widget.productToEdit!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Item' : 'Input Item'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Link Gambar'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final product = Product(
                      id: widget.productToEdit?.id ?? 0,
                      name: nameController.text,
                      description: descriptionController.text,
                      imageUrl: imageUrlController.text,
                      category: categoryController.text,
                    );
                    if (widget.productToEdit != null) {
                      context.read<ProductBloc>().add(UpdateProduct(product));
                    } else {
                      context.read<ProductBloc>().add(CreateProduct(product));
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
