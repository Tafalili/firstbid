import 'package:flutter_bloc/flutter_bloc.dart';

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    // طباعة مفصلة للتغييرات في CategoryCubit
    if (bloc.runtimeType.toString().contains('Category')) {
      print('🔄 تغيير في CategoryCubit:');
      print('   من: ${change.currentState.runtimeType}');
      print('   إلى: ${change.nextState.runtimeType}');

      if (change.nextState.toString().contains('Error')) {
        print('🚨 خطأ في CategoryCubit!');
      } else if (change.nextState.toString().contains('Success')) {
        print('✅ نجح CategoryCubit!');
      }
    }

    print('-------------------------------------------');
    print('CHANGE: ${change.runtimeType}');
    print('BLOC: ${bloc.runtimeType}');
    print('CURRENT STATE: ${change.currentState}');
    print('NEXT STATE: ${change.nextState}');
    print('-------------------------------------------');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('-------------------------------------------');
    print('CREATE: ${bloc.runtimeType}');
    if (bloc.runtimeType.toString().contains('Category')) {
      print('📦 تم إنشاء CategoryCubit جديد');
    }
    print('-------------------------------------------');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('-------------------------------------------');
    print('TRANSITION: ${transition.runtimeType}');
    print('BLOC: ${bloc.runtimeType}');
    print('EVENT: ${transition.event}');
    print('CURRENT STATE: ${transition.currentState}');
    print('NEXT STATE: ${transition.nextState}');
    print('-------------------------------------------');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('-------------------------------------------');
    print('🚨 ERROR في ${bloc.runtimeType}:');
    print('ERROR: ${error.runtimeType}');
    print('MESSAGE: $error');
    print('BLOC: ${bloc.runtimeType}');

    // طباعة تتبع المكدس المبسط
    final stackLines = stackTrace.toString().split('\n');
    print('STACK TRACE (أول 5 أسطر):');
    for (int i = 0; i < 5 && i < stackLines.length; i++) {
      print('  ${stackLines[i]}');
    }
    print('-------------------------------------------');
  }
}