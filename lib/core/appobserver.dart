import 'package:flutter_bloc/flutter_bloc.dart';

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
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
    print('ERROR: ${error.runtimeType}');
    print('BLOC: ${bloc.runtimeType}');
    print('STACK TRACE: $stackTrace');
    print('-------------------------------------------');
  }
}