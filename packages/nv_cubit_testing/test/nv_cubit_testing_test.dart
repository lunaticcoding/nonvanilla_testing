import 'package:flutter_test/flutter_test.dart';

import 'package:nv_cubit_testing/nv_cubit_testing.dart';

import 'example_cubit.dart';

void main() {
  test('emits initial state', () async {
    final states = await NvCubitTesting.collectCubitStates<ExampleCubit, int>(
      build: () => ExampleCubit(),
    );
    expect(states, [0]);
  });

  test('emits correct states in order', () async {
    final states = await NvCubitTesting.collectCubitStates<ExampleCubit, int>(
      build: () => ExampleCubit(),
      act: (cubit) async {
        cubit.increment();
        cubit.increment();
        cubit.increment();
        cubit.decrement();
        cubit.increment();
        cubit.increment();
      },
    );
    expect(states.skip(1), [1, 2, 3, 2, 3, 4]);
  });

  test('throws Exception', () async {
    try {
      await NvCubitTesting.collectCubitStates<ExampleCubit, int>(
        build: () => ExampleCubit(),
        act: (cubit) async => cubit.throwException(),
      );
    } catch (e) {
      expect(e, isException);
      expect(e.toString(), 'Exception: Test');
    }
  });
}
