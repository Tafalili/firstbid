import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/home/catigories_cubit/category_cubit.dart';
import '../screens/home/product_cubit/product_cubit.dart';
import 'categorized_products_screen.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({super.key});

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // استدعاء جلب البيانات هنا يحل مشكلة الـ context
    final categoryCubit = context.read<CategoryCubit>();
    if (categoryCubit.state is CategoryInitial) {
      categoryCubit.fetchCategories(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('جاري تحميل الفئات...'),
                ],
              ),
            ),
          );
        } else if (state is CategorySuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "categoriesTitle".tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];

                      // التحقق من وجود البيانات المطلوبة
                      final String categoryId = category['id'] ?? '';
                      final String categoryName = category['name'] ?? 'بدون اسم';
                      final String iconUrl = category['icon_url'] ?? '';

                      if (categoryId.isEmpty) {
                        print('تحذير: فئة بدون معرف في الفهرس $index');
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (categoryId.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ProductCubit(),
                                    child: CategorizedProductsScreen(
                                      categoryId: categoryId,
                                      categoryName: categoryName,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('خطأ: معرف الفئة غير صحيح'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[200],
                                child: iconUrl.isNotEmpty
                                    ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: iconUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.category,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : const Icon(
                                  Icons.category,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 60,
                                child: Text(
                                  categoryName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is CategoryError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 10),
                Text(
                  'خطأ في تحميل الفئات',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<CategoryCubit>().fetchCategories(context);
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}