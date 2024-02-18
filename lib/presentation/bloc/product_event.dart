part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class LoadProduct extends ProductEvent {}

class CreateProduct extends ProductEvent {
  final Product product;

  CreateProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final Product product;

  UpdateProduct(this.product);
}

class DeleteProduct extends ProductEvent {
  final int id;

  DeleteProduct(this.id);
}

class SearchProduct extends ProductEvent {
  final String query;

  SearchProduct(this.query);
}
