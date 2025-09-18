import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bidmarket/domain/entities/user.dart' as user_entity;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  SupabaseClient client = Supabase.instance.client;

  Future<void> signUpWithPassword({
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final AuthResponse response = await client.auth.signUp(
        phone: phoneNumber,
        password: password,
      );
      if (response.user == null) {
        emit(AuthError('Failed to send OTP. Please try again.'));
      } else {
        // 🆕 إصدار حالة OtpSent وإرسال الاسم ورقم الهاتف
        emit(OtpSent(phoneNumber, name: name));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> signInWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final AuthResponse response = await client.auth.signInWithPassword(
        phone: phoneNumber,
        password: password,
      );
      if (response.user != null) {
        emit(AuthSuccess(user: response.user));
      } else {
        emit(AuthError('Failed to sign in. Please check your credentials.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      final response = await client.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      if (response.user != null) {
        // 🆕 استدعاء SendingData هنا بعد التحقق الناجح
        // مع تمرير الاسم ورقم الهاتف
        await SendingData(
          name: name,
          email: response.user!.email!,
          phoneNumber: phoneNumber,
        );
        emit(AuthSuccess(user: response.user));
      } else {
        emit(AuthError('Failed to verify OTP. Please try again.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    }
  }

  Future<void> nativeGoogleSignIn() async {
    emit(GoogleSignInLoading());
    try {
      const webClientId = '503210863886-dnsb6ifi57vqq9vhgfcafg7bdn286keu.apps.googleusercontent.com';
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google Sign-In canceled by user.';
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null || idToken == null) {
        throw 'No Access Token or ID Token found.';
      }
      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      if (client.auth.currentUser != null) {
        // تعديل: يجب أن ترسل رقم الهاتف هنا إذا كان متاحًا
        await SendingData(
            name: googleUser.displayName!, email: googleUser.email, phoneNumber: null);
        emit(GoogleSignInSuccess());
      } else {
        emit(GoogleSignInError('Failed to sign in with Google.'));
      }
    } catch (e, stack) {
      print("Google Sign-In Error: $e");
      print(stack);
      emit(GoogleSignInError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(SignOutLoading());
    try {
      await client.auth.signOut();
      emit(SignOutSuccess());
    } on AuthException catch (e) {
      print("Sign-Out Error: $e");
      emit(SignOutError(e.message));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(ResetPasswordLoading());
      await client.auth.resetPasswordForEmail(email);
      emit(ResetPasswordSuccess());
    } on AuthException catch (e) {
      print("Error in reset password: $e");
      emit(ResetPasswordError());
    }
  }

  Future<void> SendingData({required String name, required String email, String? phoneNumber}) async {
    emit(SendingDataLoading());
    try {
      // 🆕 إضافة رقم الهاتف إلى الـ Map
      await client.from('profiles').upsert({
        'id': client.auth.currentUser!.id,
        'full_name': name,
        'phone_number': phoneNumber,
      });
      emit(SendingDataSuccess());
    } catch (e) {
      print("sending data error: $e");
      emit(SendingDataError());
    }
  }
}