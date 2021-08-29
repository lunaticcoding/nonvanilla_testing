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

## Getting Started
This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
