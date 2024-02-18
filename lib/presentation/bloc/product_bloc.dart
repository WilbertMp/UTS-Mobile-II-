import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utsmobilewilbert/data/datasource/remote_datasource.dart';
import 'package:utsmobilewilbert/data/model/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final RemoteDataSource remoteDataSource;
  ProductBloc({required this.remoteDataSource}) : super(ProductInitial()) {
    on<LoadProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final result = await remoteDataSource.getProducts();
        print(result);
        emit(ProductLoaded(result));
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });
    on<CreateProduct>((event, emit) async {
      try {
        final createdProduct =
            await remoteDataSource.createProduct(event.product);
        if (state is ProductLoaded) {
          final updatedProducts =
              (state as ProductLoaded).products + [createdProduct];
          emit(ProductLoaded(updatedProducts));
        }
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });

    on<UpdateProduct>((event, emit) async {
      try {
        final updatedProduct =
            await remoteDataSource.updateProduct(event.product);
        if (state is ProductLoaded) {
          final updatedProducts = (state as ProductLoaded)
              .products
              .map((note) =>
                  note.id == updatedProduct.id ? updatedProduct : note)
              .toList();
          emit(ProductLoaded(updatedProducts));
        }
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });

    on<DeleteProduct>((event, emit) async {
      try {
        await remoteDataSource.deleteProduct(event.id);
        if (state is ProductLoaded) {
          final remainingProducts = (state as ProductLoaded)
              .products
              .where((Note) => Note.id != event.id)
              .toList();
          emit(ProductLoaded(remainingProducts));
        }
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });

    on<SearchProduct>((event, emit) async {
      emit(ProductLoading());
      try {
        final result = await remoteDataSource.getProducts();
        emit(ProductLoaded(result));
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });
  }
}
