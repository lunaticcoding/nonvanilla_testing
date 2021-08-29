import 'package:example/navigation_cubit_cg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nv_cubit_testing/nv_cubit_testing.dart';

Future<void> main() async {
  test('has only the initial Page', () {
    final initialPage = MaterialPage(child: Container());
    final cubit = NavigationCubit(initialPage: initialPage);

    expect(cubit.state.pages, [initialPage]);
  });

  test('push adds second page', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());
    final secondPage = MaterialPage(name: 'second', child: Container());

    final states = await NvCubitTesting.collectCubitStates(
      build: () => NavigationCubit(initialPage: initialPage),
      act: (NavigationCubit navigator) async => navigator.push(secondPage),
    );

    expect(states.last.pages, [initialPage, secondPage]);
  });

  test('pop removes second page', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());
    final secondPage = MaterialPage(name: 'second', child: Container());

    final states = await NvCubitTesting.collectCubitStates(
      build: () => NavigationCubit(initialPage: initialPage),
      act: (NavigationCubit navigator) async {
        navigator.push(secondPage);
        navigator.pop();
      },
    );

    expect(states.last.pages, [initialPage]);
  });

  test('replace initial page with second page', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());
    final secondPage = MaterialPage(name: 'second', child: Container());

    final states = await NvCubitTesting.collectCubitStates(
      build: () => NavigationCubit(initialPage: initialPage),
      act: (NavigationCubit navigator) async => navigator.replace(secondPage),
    );

    expect(states.last.pages, [secondPage]);
  });

  test('pop on pages.length = 1 throws exception', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());

    try {
      await NvCubitTesting.collectCubitStates(
        build: () => NavigationCubit(initialPage: initialPage),
        act: (NavigationCubit navigator) async => navigator.pop(),
      );

      // if this is reached the test should fail!
      expect(true, false);
    } catch (e) {
      expect(e, isA<RangeError>());
    }
  });

  test('popNAndPush works accordingly', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());
    final additionalPage = MaterialPage(name: 'additional', child: Container());

    final states = await NvCubitTesting.collectCubitStates(
      build: () => NavigationCubit(initialPage: initialPage),
      act: (NavigationCubit navigator) async {
        navigator.push(additionalPage);
        navigator.push(additionalPage);
        navigator.push(additionalPage);
        navigator.push(additionalPage);
        navigator.popNAndPush(additionalPage, n: 5);
      },
    );

    expect(states.last.pages, [additionalPage]);
  });
}
