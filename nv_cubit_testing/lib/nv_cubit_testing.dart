library nv_cubit_testing;

import 'package:bloc/bloc.dart';

class NvCubitTesting {
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
