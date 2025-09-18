import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bidmarket/presentation/cubit/auth/auth_cubit.dart';
import 'package:bidmarket/presentation/screens/auth/login_screen.dart';

import '../cubit/themedata/theme_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'userInformation'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text('completedOrders'.tr()),
            onTap: () {
              // TODO: Navigate to completed orders screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text('contactUs'.tr()),
            onTap: () {
              // TODO: Navigate to contact us screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('aboutUs'.tr()),
            onTap: () {
              // TODO: Navigate to about us screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text('shareApp'.tr()),
            onTap: () {
              // TODO: Implement share functionality
              Navigator.pop(context);
            },
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                title: Text(
                  themeMode == ThemeMode.dark
                      ? 'lightMode'.tr()
                      : 'darkMode'.tr(),
                ),
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('languages'.tr()),
            trailing: DropdownButton<String>(
              value: context.locale.languageCode,
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('english'.tr()),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text('arabic'.tr()),
                ),
              ],
              onChanged: (String? newLocale) {
                if (newLocale != null && newLocale != context.locale.languageCode) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('تأكيد تغيير اللغة'),
                        content: Text('هل أنت متأكد من أنك تريد تغيير اللغة؟ سيتم إعادة تشغيل التطبيق.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.setLocale(Locale(newLocale));
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    (Route<dynamic> route) => false,
                              );
                            },
                            child: Text('موافق'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.tr()),
            onTap: () async {
              await context.read<AuthCubit>().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}