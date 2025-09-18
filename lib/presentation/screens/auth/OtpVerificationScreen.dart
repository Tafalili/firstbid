import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bidmarket/presentation/cubit/auth/auth_cubit.dart';
import 'package:bidmarket/presentation/widgets/common_widgets.dart';

import '../home/HomeScreen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;


  const OtpVerificationScreen({super.key, required this.phoneNumber, required this.name});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التحقق من رقم الهاتف', style: TextStyle(color: Colors.white)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تم إرسال رمز تحقق إلى رقم الهاتف ${widget.phoneNumber}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    CustomTextFormField(
                      controller: _otpController,
                      labelText: 'رمز التحقق',
                      icon: Icons.sms,
                      validator: (value) => value!.isEmpty ? 'الرجاء إدخال الرمز' : null,
                    ),
                    const SizedBox(height: 32),
                    CustomElevatedButton(
                      text: 'تأكيد الرمز',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(context).verifyOtp(
                            phoneNumber: widget.phoneNumber,
                            otp: _otpController.text,
                            name: widget.name, // 🆕 تمرير الاسم هنا
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
