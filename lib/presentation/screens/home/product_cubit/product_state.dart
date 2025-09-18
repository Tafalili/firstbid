import 'package:bidmarket/presentation/screens/home/product_cubit/products.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<Products> products;

  ProductSuccess(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
