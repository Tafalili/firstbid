import 'package:bidmarket/presentation/screens/home/product_cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bidmarket/presentation/widgets/app_drawer.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../widgets/home_categories.dart';
import '../../widgets/home_corasel.dart';
import '../../widgets/home_products_grid.dart';
import '../../widgets/logic_corasel/carousel_cubit.dart';
import 'catigories_cubit/category_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    Text('favorites'.tr()),
    Text('myBids'.tr()),
    Text('myPurchases'.tr()),
    Text('notifications'.tr()),
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
        title: Text('appTitle'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'favorites'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.gavel),
            label: 'myBids'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: 'myPurchases'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: 'notifications'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocProvider(
            create: (context) => CarouselCubit(),
            child: const HomeCarousel(),
          ),
          BlocProvider(
            create: (context) => CategoryCubit(),
            child: const HomeCategories(),
          ),
          // إنشاء widget منفصل
          BlocProvider(
            create: (context) => ProductCubit(),
            child: const ProductsWrapper(), // Widget جديد
          ),
        ],
      ),
    );
  }
}

class ProductsWrapper extends StatefulWidget {
  const ProductsWrapper({super.key});

  @override
  State<ProductsWrapper> createState() => _ProductsWrapperState();
}

class _ProductsWrapperState extends State<ProductsWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeProductsGrid();
  }
}
