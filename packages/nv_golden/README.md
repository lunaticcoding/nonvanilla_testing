# NvGolden (v1.0.0-beta)

## Table of Contents

- [NvGolden](#nvgolden)
  - [init](#init)
  - [singular](#singular)
  - [grid](#grid)
  - [devices](#devices)
- [Golden Creation](#golden-creation)
  - [createGolden](#creategolden)
  - [createSequenceGolden](#createsequencegolden)
- [Display](#display)
  - [Device](#device)
  - [Screen](#screen)
- [Gestures](#gestures)
  - [tap](#tap)

## NvGolden

### init
The init method has to be called before running any golden test which includes text or icons. The init method attempts to load all fonts registered within the pubspec.yaml file. If init is unable to load your fonts you can manually load them using `NvGolden.loadFont(...)`. Without your fonts being loaded, your screenshots will display black squares instead of readable text. 
```dart
setUpAll(NvGolden.init);

// Or alternatively (in case your fonts aren't automatically picked up)
setUpAll(() => Future.wait([
    NvGolden.init(),
    NvGolden.loadFont(
      name: 'Roboto',
      paths: ['lib/fonts/Roboto-Regular.ttf'],
    ),
  ]),
);
```

### singular
The singular constructor allows you to render a single scenario. This is especially useful when added to regular widget tests so you can see what is being rendered during your test. 

```dart
testWidgets('your test name', (tester) async {
    final nvGolden = NvGolden.singular(
      widget: nvWrapper.wrap(YourWidget(...)),
      screen: Screen(size: Size(200, 100)),
    );

    await tester.createGolden(nvGolden, 'your-golden-name');

    // Expect statements have to happen after the createGolden or createSequenceGolden call
    // because those calls also take care of pumping your widget!
    expect(find.byType(YourWidget), findsOneWidget);
});
```

### grid
The grid constructor allows you to render a several golden scenarios into a single file.

```dart
testWidgets('your test name', (tester) async {
  final nvGolden = NvGolden.grid(
    nrColumns: 2, 
    screen: Screen(size: Size(200, 100)),
  )
    ..addScenario(
      name: 'Icon 1',
      widget: nvWrapper.wrap(YourWidget(...)),
    )
    ..addScenario(...)
    ..addScenario(...)
    ..addScenario(...);

    await tester.createGolden(nvGolden, 'your-golden-name');

    // Expect statements have to happen after the createGolden or createSequenceGolden call
    // because those calls also take care of pumping your widget!
    // Keep in mind that your widget will be rendered once per scenario!
    expect(find.byType(YourWidget), findsNWidgets(4));
});
```

### devices
The devices constructor renders every scenario once per device. It is highly recommended to add these test on a page/screen level with a very small device (such as the `Device.iphone5s`) and a rather large one (such as the 'Device.iphone12proMax`) to ensure your designs look nice on big screens and don't overflow on small ones.

```dart
testWidgets('your test name', (tester) async {
  final nvGolden = NvGolden.devices(
    deviceSizes: [Device.iphone5s, Device.iphone12proMax],
  )
  ..addScenario(
    name: 'scenario name',
    widget: YourWidgt(...),
  )
  ..addScenario(...);

  await tester.createGolden(nvGolden, 'your-golden-name');

  // Expect statements have to happen after the createGolden or createSequenceGolden call
  // because those calls also take care of pumping your widget!
  // Keep in mind that your widget will be rendered once per Device for every scenario!
  expect(find.byType(YourWidget), findsNWidgets(4));
});
```
## Golden Creation
The golden creation methods are extensions on the WidgetTester instance. They'll take an instance of NvGolden as the first argument and the name of the golden file as the second one.

### createGolden
The `createGolden(...)` method renders the NvGolden instances scenario(s). For singular Goldens it will merely render the widget while it will add a title for both the `grid` and the `devices` constructor.

```dart
await tester.createGolden(nvGolden, 'your-golden-name');
```

Example Grid: <br>
<img width="200px" src="https://user-images.githubusercontent.com/86478606/154091424-e729a3de-89a4-4bf1-9a28-036cb34998ee.png" />


Example Device: <br>
<img width="200px" src="https://user-images.githubusercontent.com/86478606/154091454-7cee7483-c4f5-4563-858e-99e09fc19a1b.png" />

### createSequenceGolden
During widget testing one might also want to tap certain elements on the screen (maybe even several of them in order). This is where Sequence testing comes in. It renders where the tap event(s) occurred to also add a visible check whether the correct element was clicked or not. 

`createSequenceGolden(...)` is only compatible with `NvGolden.singular(...)`.

```dart
await tester.createSequenceGolden(
  nvGolden,
  'your-golden-name',
  // Renders taps and optionally applies them to the pumped widget
  gestures: [NvGesture.tap(finder: finder)],
);
```

Example: <br>
<img width="200px" src="https://user-images.githubusercontent.com/86478606/154092011-19785a0d-a90b-4a1f-a08b-0be8434d0dd8.png" />


## Display
The golden builder methods need to know how much space is available to the widget being rendered. 
### Device
`Device` is an abstract class holding some common test devices readily available for you.
### Screen
You can also create your own `Device` using the Screen class. 

```dart
Screen(
   name: 'Iphone 12 Pro',
  size: Size(390, 844),
  safeArea: const EdgeInsets.fromLTRB(0.0, 47.0, 0.0, 34.0),
);
```

## Gestures
`createSequenceGolden` allows for interactive golden testing. All gestures are rendered on the golden first and applied after the golden file has been saved. The result of a sequence golden will be used as the input for the following sequence golden.  
### tap
`tap` simulates a tap event on the specified finder. This is currently the only Gesture implemented. More are soon to come. 
