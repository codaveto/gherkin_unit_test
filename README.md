# Gherkin Unit Test

# 🧪 Gherkin Unit Test

---

<aside>
💡 The example project has a test folder where the example project is being fully tested with this framework. Check that out if you’re not that into reading good documentation 😏.

</aside>

This package is based on the Behaviour Driven Development (BDD) language called Gherkin. This language enables us as developers to design and execute tests in an intuitive and readable way. For people who have a little less experience with development, these tests are also easy to understand because the syntax is very similar to English.

![https://media.giphy.com/media/l0MYODQzHE3ibZ62A/giphy.gif](https://media.giphy.com/media/l0MYODQzHE3ibZ62A/giphy.gif)

Most tests look something like this:

```gherkin
Feature: This feature shows an example

    Scenario: It shows a good example
      Given we start without an example
      When an example gets created
      Then the example should explode
```

In this same we have built our framework, we have the following classes at our disposal:

- `UnitTest`
- `UnitFeature`
- `UnitScenario`
- `UnitExample`
- `UnitStep` (abstract)
  - `Given`
  - `When`
  - `Then`
  - `And`
  - `But`

From top to bottom, each class may contain a number of the class below it (one to many). A test may contain multiple features which in turn may contain multiple scenarios. Scenarios can then (optionally) run different examples in which they perform a series of steps.

<aside>
💡 *In this guide we will instantiate most classes on the fly and describe them with a `description` parameter. This feels more natural and intuitive when creating tests. However, you may also choose to inherit the classes and override values as you see fit. This may allow for more structure and will give you a little more flexibility as to adding your own classes / values inside the implementations, because working from the constructor will not allow any access to values inside the class. That being said most of the time you won’t need to add your own classes because this framework provides you with enough flexibility through `setUp` / `tearDown` methods and the passing of results through steps (more on that later).*

</aside>

## 🥼 Basic testing knowledge

---

- Before continuing this guide make sure you have basic testing knowledge regarding writing unit tests in Flutter. The following resource is a great place to start:

  [An introduction to unit testing](https://docs.flutter.dev/cookbook/testing/unit/introduction)

- Be sure to have a look at the `expect library` of the `flutter_test` package. You don’t have to know every method that’s available but it’s good to have seen most methods at least once so you know what’s possible. This library should be used to assert outcomes of your tests.

  [expect library - Dart API](https://api.flutter.dev/flutter/package-test_api_expect/package-test_api_expect-library.html)

- Last but not least, we use the `mockito` package to mock services when needed, check out their page and specifically how to stub and how the `@GenerateMocks([])` annotation works.

  [mockito | Dart Package](https://pub.dev/packages/mockito)


## 🛠 Implementation

---

Start by creating a test class that inherits the `UnitTest` class. Then create a constructor that takes no arguments but does call the superclass with a `description` and (for now) an empty list of `features`.

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [],
        );
}
```

<aside>
💡 *We will not get into specifics on how to use mocks and / or how to create them, just know that we use the `@GenerateMocks([])` annotation to easily create and stub mocks of desired classes. For more info on the annotation and mocks in general check out the link mentioned in **🥼 Basic testing knowledge** above.*

</aside>

### 📲 Features

---

In the `features` list we can now define our first `UnitFeature`. We give it a name and (for now) an empty list of `scenarios`.

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature(
              description: 'Saving of dummies',
              scenarios: [],
            ),
          ],
        );
}
```

### 🤝 Scenarios

---

Now it's time to think about what kind of `scenarios` might occur in your test. Often this is already well thought out in advance when preparing a ticket. For this example we will use ’a successful save’ and ‘an unsuccessful save’ as possible `scenarios`. We use the `UnitScenario` class to create both `scenarios` and place them in the empty list. The scenario is also the place where we define the `systemUnderTest` that we would like to test. This paramater takes a callback where you may perform any logic to initialise the `systemUnderTest`. This callback is carried out after any `setUp` methods you specify (more on those methods later). This resembles the unit that we want to test and is a required parameter in each `UnitScenario`. In this example we’ll use a `DummyService()`. We also pass in a `description` and this time an empty list of `steps`.

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTests()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature(
              description: 'Saving of dummies',
              scenarios: [
                UnitScenario<DummyService>(
                  description: 'Saving a good dummy should succeed',
                  systemUnderTest: DummyService(),
                  steps: [],
                ),
                UnitScenario<DummyService>(
                  description: 'Saving a bad dummy should fail',
                  systemUnderTest: DummyService(),
                  steps: [],
                ),
              ],
            ),
          ],
        );
}
```

<aside>
💡 *Give your scenario the generic type of your systemUnderTest so it automatically comes as the right type in the next step.*

</aside>

### 🐾 Steps

---

Now comes the good part. For each scenario, we may define `steps`. We have access to `Given`, `When`, `Then`, `And` and `But`. All of these steps do basically the same thing in the background, but by using them correctly, you learn to plan, work out and execute your tests in an intuitive and proper BDD way.

Each step requires a description and a callback. The callback for the `UnitTests` looks as follows and grants access to the following parameters:

```dart
/// Callback used to provide the necessary tools to execute an [UnitStep].
typedef UnitStepCallback<SUT, Example extends UnitExample?> = FutureOr<dynamic> Function(
  SUT systemUnderTest,
  Log log, [
  Example? example,
  Object? result,
]);
```

- `SUT systemUnderTest`
  - The class that we specified earlier in the `UnitScenario` that resembles the unit that we want to test.
- `Log log`
  - Class that allows for subtle logging of steps information in your tests.
- `UnitExample? example`
  - Optional ‘Scenario Outline’ examples that we’ll get to later, in short these are different inputs for the same scenario so you can run / cover different variations of one scenario.
- `Object? result`
  - Each step is able to optionally return a value, may this be the case then this value is available to you in the next step as a `result`.

Setting up the success scenario may look like this:

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature(
              description: 'Saving of dummies',
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  systemUnderTest: DummyService(),
                  steps: [
                    Given(
                      'The dummy service is initialised',
                      (systemUnderTest, log, [_, __]) {
                        // TODO(you): Initialise service
                      },
                    ),
                    When(
                      'We call the dummy service with dummy info',
                      (systemUnderTest, log, [example, result]) {
                        // TODO(you): Call dummy service with dummy info
                      },
                    ),
                    Then(
                      'It should succeed',
                      (systemUnderTest, log, [example, result]) {
                        // TODO(you): Verify success
                      },
                    ),
                  ],
                ),
                UnitScenario(
                  description: 'Saving a bad dummy should fail',
                  systemUnderTest: DummyService(),
                  steps: [
                    // TODO(you): Implement fail steps
                  ],
                ),
              ],
            ),
          ],
        );
}
```

While this may perfectly fit our testing needs there are a couple functionalities at our disposal that give our tests extra power:

- `UnitExample`
- `setUp` and `tearDown` methods

### **🏆 Bonus UnitSteps**

---

- `GivenWhenThen`
  - For when you can’t be bothered to create and use the separate step functionality regarding the ‘Given’, ‘When’ and ‘Then’ steps. This allows you to write the entire test in one step.
- `WhenThen`
  - For when you can’t be bothered to create and use the separate step functionality regarding the ‘When’ and ‘Then’ steps. This allows you to combine both steps into one.
- `Should`
  - For when you feel like using steps is not your style. This step defines the entire test in one ‘Should’ sentence.

### 🧪 Examples

---

Let’s continue with our test demonstrated above. For the succeeding scenario of ‘saving a good dummy should succeed’ we’re going to add some `examples`. Each example will get run through the specified `steps` in your scenario and each example will be accessible through the `example` parameter. Let’s start with adding an `example` where we specify the platform and the current connection status.

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature(
              description: 'Saving of dummies',
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  systemUnderTest: DummyService(),
                  examples: [
                    UnitExample(
                      description: 'Platform is iOS, Connection status is online',
                      values: [Platform.iOS, Connection.online],
                    ),
                    UnitExample(
                      description: 'Platform is Android, Connection status is online',
                      values: [Platform.android, Connection.online],
                    ),
                    UnitExample(
                      description: 'Platform is iOS, Connection status is offline',
                      values: [Platform.iOS, Connection.offline],
                    ),
                    UnitExample(
                      description: 'Platform is Android, Connection status is offline',
                      values: [Platform.android, Connection.offline],
                    ),
                  ],
                  steps: [
                    Given(
                      'The dummy service is initialised',
                      (systemUnderTest, log, [_, __]) {
                        // TODO(you): Initialise service
                      },
                    ),
                    When(
                      'We call the dummy service with dummy info',
                      (systemUnderTest, log, [example, result]) {
                        // TODO(you): Call dummy service with dummy info
                      },
                    ),
                    Then(
                      'It should succeed',
                      (systemUnderTest, log, [example, result]) {
                        // TODO(you): Verify success
                      },
                    ),
                  ],
                ),
                UnitScenario(
                  description: 'Saving a bad dummy should fail',
                  systemUnderTest: DummyService(),
                  steps: [
                    // TODO(you): Implement fail steps
                  ],
                ),
              ],
            ),
          ],
        );
}
```

So for each example:

- 'Platform is iOS, Connection status is online'
- 'Platform is Android, Connection status is online'
- 'Platform is iOS, Connection status is offline'
- 'Platform is Android, Connection status is offline'

It will now run each step (`Given`, `When`, `Then`) inside the 'Saving a good dummy should succeed' scenario. You may now access the example values in the following way:

```dart
Given(
  'The dummy service is initialised',
  (systemUnderTest, log, [example, _]) {
    final Platform platform = example.firstValue();
    final Connection connection = example.secondValue();
  },
),
```

<aside>
💡 *Be sure to make your declaration type safe, because the `firstValue()` helper method will `cast` the value to whatever type your specify, use with caution!*

</aside>

### 🏗 setUpOnce, setUpEach, tearDownOnce, tearDownEach

---

Another handy way to empower your tests is by using one of several `setUp` and `tearDown` methods. Each class has access to these methods and will run them in sort of the same way:

- `setUpEach` - will run at the START of EACH `UnitScenario` under the chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `tearDownEach` - will run at the END of EACH `UnitScenario` under the chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `setUpOnce` - will run ONCE at the START of chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `tearDownOnce` - will run ONCE at the END of chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).

<aside>
💡 *So a good way to remember which method does what is that all the `each` methods will run per `UnitScenario` / `UnitExample` **under the defining class that holds the method** and all the `once` methods will run **once in the defining class that holds the method**.*

</aside>

Using the methods may look a bit like this:

```dart
@GenerateMocks([])
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          setUpOnce: () async {
            await AppSetup.initialise(); // Runs once at the start of this test.
          },
          tearDownOnce: () async {
            await AppSetup.dispose(); // Runs once at the end of this test.
          },
          features: [
            UnitFeature(
              description: 'Saving of dummies',
              tearDownEach: () {
                // TODO(you): Reset to dummy screen at the end of each scenario or example in this feature.
              },
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  setUpEach: () {
                    // TODO(you): Reset dummy status at the start of this scenario or each example in this scenario.
                  },
                  examples: // etc, rest of code
```

Now to run these tests all you have to do is add the `DummyUnitTests` to your main test function and hit run.
