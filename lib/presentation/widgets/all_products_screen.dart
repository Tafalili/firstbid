import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../screens/home/product_cubit/product_cubit.dart';
import '../screens/home/product_cubit/product_state.dart';
import 'home_products_grid.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all products when the screen is initialized
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جميع المزادات'),
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
            // Get current time
            final now = DateTime.now();

            // Separate ongoing and ended auctions
            final ongoingAuctions = state.products
                .where((p) => DateTime.tryParse(p.endDate ?? '')?.isAfter(now) ?? false)
                .toList()
              ..sort((a, b) {
                final aEndDate = DateTime.tryParse(a.endDate ?? '');
                final bEndDate = DateTime.tryParse(b.endDate ?? '');
                if (aEndDate == null || bEndDate == null) return 0;
                return aEndDate.compareTo(bEndDate);
              });

            final endedAuctions = state.products
                .where((p) => DateTime.tryParse(p.endDate ?? '')?.isBefore(now) ?? false)
                .toList();

            // Combine them with ongoing first
            final sortedProducts = [...ongoingAuctions, ...endedAuctions];

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: sortedProducts.length,
              itemBuilder: (context, index) {
                return AuctionProductCard(product: sortedProducts[index]);
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
