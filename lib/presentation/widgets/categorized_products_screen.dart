import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../screens/home/product_cubit/product_cubit.dart';
import '../screens/home/product_cubit/product_state.dart';
import 'home_products_grid.dart';

class CategorizedProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategorizedProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _CategorizedProductsScreenState createState() => _CategorizedProductsScreenState();
}

class _CategorizedProductsScreenState extends State<CategorizedProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products based on the category ID
    context.read<ProductCubit>().fetchProducts(categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductSuccess) {
            final allProducts = state.products
              ..sort((a, b) {
                final aEndDate = DateTime.tryParse(a.endDate ?? '');
                final bEndDate = DateTime.tryParse(b.endDate ?? '');
                if (aEndDate == null || bEndDate == null) {
                  return 0;
                }
                return aEndDate.compareTo(bEndDate);
              });

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                return AuctionProductCard(product: allProducts[index]);
              },
            );
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
