import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bidmarket/presentation/cubit/auth/auth_cubit.dart';
import 'package:bidmarket/presentation/widgets/common_widgets.dart';


import '../home/HomeScreen.dart';
import 'OtpVerificationScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // Navigate to HomeScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            // 🆕 الاستماع لحالة OtpSent
            else if (state is OtpSent) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OtpVerificationScreen(
                    phoneNumber: state.phoneNumber,
                    name: state.name, // 🆕 تمرير الاسم هنا
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'الاسم الثلاثي',
                        icon: Icons.person,
                        validator: (value) => value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _phoneNumberController,
                        labelText: 'رقم الهاتف',
                        icon: Icons.phone,
                        validator: (value) => value!.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: 'كلمة المرور',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? 'الرجاء إدخال كلمة المرور' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        labelText: 'تأكيد كلمة المرور',
                        icon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء تأكيد كلمة المرور';
                          } else if (value != _passwordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      CustomElevatedButton(
                        text: 'إنشاء حساب',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context).signUpWithPassword(
                              name: _nameController.text,
                              phoneNumber: _phoneNumberController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
