# nv_cubit_testing

Cubit testing plugin used by NonVanilla.

## Advantages

Gets rid of global variables (compared to bloc_test):

#### bloc_test
```dart
final initialPage = MaterialPage(name: 'initial', child: Container());
final secondPage = MaterialPage(name: 'second', child: Container());

blocTest<NavigationCubit, Page>(
      'push adds second page',
      build: () => NavigationCubit(initialPage: initialPage),
      act: (navigator) => navigator.push(secondPage),
      expect: () => [initialPage, secondPage],
    );
```

#### nv_cubit_testing
```dart
test('push adds second page', () async {
    final initialPage = MaterialPage(name: 'initial', child: Container());
    final secondPage = MaterialPage(name: 'second', child: Container());

    final states = await NvCubitTesting.collectCubitStates(
      build: () => NavigationCubit(initialPage: initialPage),
      act: (NavigationCubit navigator) async => navigator.push(secondPage),
    );

    expect(states.last.pages, [initialPage, secondPage]);
});
```

## withState extension
Makes mocking the state (with mockito) easier.

```
// Instead of
final mockBloc = MockBloc();
when(state).thenAnswer((_) => CubitState());
when(stream).thenAnswer((_) => CubitState());

// We write
final mockBloc = MockBloc();
mockBloc.withState(CubitState());
```