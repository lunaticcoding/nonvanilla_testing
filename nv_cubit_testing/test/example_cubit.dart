import 'package:bloc/bloc.dart';

class ExampleCubit extends Cubit<int> {
  ExampleCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
  void throwException() => throw Exception('Test');
}
