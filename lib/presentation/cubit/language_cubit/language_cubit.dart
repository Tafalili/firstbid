import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageCubit extends Cubit<Locale> {
LanguageCubit() : super(const Locale('en'));

void changeLocale(BuildContext context, Locale newLocale) {
if (state != newLocale) {
EasyLocalization.of(context)?.setLocale(newLocale);
emit(newLocale);
}
}
}