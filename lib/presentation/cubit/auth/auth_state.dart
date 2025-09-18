part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User? user;
  AuthSuccess({this.user});
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class OtpSent extends AuthState {
  final String phoneNumber;
  final String name; // إضافة متغير الاسم
  OtpSent(this.phoneNumber, {required this.name});
}


// Google Sign-In states
class GoogleSignInLoading extends AuthState {}
class GoogleSignInSuccess extends AuthState {}
class GoogleSignInError extends AuthState {
  final String message;
  GoogleSignInError(this.message);
}

// Sign-out states
class SignOutLoading extends AuthState {}
class SignOutSuccess extends AuthState {}
class SignOutError extends AuthState {
  final String message;
  SignOutError(this.message);
}

// Password reset states
class ResetPasswordLoading extends AuthState {}
class ResetPasswordSuccess extends AuthState {}
class ResetPasswordError extends AuthState {}

// Data sending states
class SendingDataLoading extends AuthState {}
class SendingDataSuccess extends AuthState {}
class SendingDataError extends AuthState {}

