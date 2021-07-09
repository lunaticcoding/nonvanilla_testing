library nv_cubit_testing;

import 'package:bloc/bloc.dart';
import 'package:mockito/mockito.dart';

/// A wrapper to increase discoverability should more methods be added in the
/// future.
class NvCubitTesting {
  /// Method to collect all states emitted by the actions performed on the
  /// cubit and cleans everything up.
  /// Returns a List of states.
  static Future<List<T>> collectCubitStates<C extends Cubit<T>, T>({
    required C Function() build,
    Future<void> Function(C cubit)? act,
  }) async {
    final cubit = build();
    final List<T> states = [cubit.state];

    final subscription = cubit.stream.listen(states.add);

    await act?.call(cubit);

    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    await subscription.cancel();

    return states;
  }
}

extension CubitWhen<T> on Cubit<T> {
  void withState(T cubitState) {
    when(state).thenAnswer((_) => cubitState);
    when(stream).thenAnswer((_) => Stream.value(cubitState));
  }
}
