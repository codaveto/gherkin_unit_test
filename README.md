# 🧪 Gherkin Unit Test

---

<aside>
❗ The example project has a test folder where the example project is being fully tested with this framework.

</aside>

This package is based on the `Behaviour Driven Development` (BDD) language called `Gherkin`. This language enables us as developers to design and execute tests in an intuitive and readable way. For people who have a little less experience with development, these tests are also easy to understand because the syntax is very similar to English.

![gherkin.jpg](gherkin.jpg)

Most tests look something like this:

```gherkin
Feature: This feature shows an example

    Scenario: It shows a good example
      Given we start without an example
      When an example gets created
      Then the example should explode
```

In this same way we have built our framework, we have the following classes at our disposal:

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

From top to bottom, each class may contain a number of the class below it (one to many). A `UnitTest` may contain multiple `UnitFeature` which in turn may contain multiple `UnitScenario` which in turn may contain multiple `UnitStep`.

## 🛠 Implementation

---

Start by creating a test class that inherits the `UnitTest` class. Then create a constructor that takes no arguments but does call the superclass with a `description` and (for now) an empty list of `features`.

```dart
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [],
        );
}
```

### 📲 Features

---

In the `features` list we can now define our first `UnitFeature`. We give it a name and (for now) an empty list of `scenarios`.

The `UnitFeature` is also the place where we (for this example) define the `systemUnderTest` that we would like to test.

<aside>
💡 You may also define a `systemUnderTest` higher up or lower down the tree in either a `UnitTest` or `UnitScenario,` doing so will ensure that the `systemUnderTest` will persist inside the respective class. Any `systemUnderTest` defined lower down the tree will get precedence over any `systemUnderSystem` defined higher up the tree.

</aside>

This paramater takes a callback where you may perform any logic to initialise the `systemUnderTest`. This callback is carried out after before any `setUp` methods you specify in that class.

<aside>
💡 The `systemUnderTest` callback also gives you access to a `UnitMock` object. You may optionally use this object to store mocks for your `systemUnderTest` so you may later retrieve them to reset or stub methods to your liking.

</aside>

In this example we’ll use a `DummyService()` as our `systemUnderTest`. The `DummyService` gets a `dummyMock` as its parameter which we will save to the `UnitMocks` object so we can later manipulate it as we see fit.

```dart
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature<DummyService>(
              description: 'Saving of dummies',
              systemUnderTest: (mocks) {
                final dummyMock = DummyMock();
                mocks.write(dummyMock);
                return DummyService(dummyDependency: dummyMock);
              },
              scenarios: [],
            ),
          ],
        );
}
```

<aside>
💡 Give your class the generic type of your `systemUnderTest` so it automatically comes as the right type in the `UnitScenario`’s `UnitStep`’s later down the tree.

</aside>

### 🤝 Scenarios

---

Now it's time to think about what kind of `scenarios` might occur in your test. For this example we will use ’a successful save’ and ‘an unsuccessful save’ as possible `scenarios`.

We use the `UnitScenario` class to create both `scenarios` and place them in the empty list. We also pass in a `description` and this time an empty list of `steps`.

```dart
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature<DummyService>(
              description: 'Saving of dummies',
              systemUnderTest: (mocks) {
                final dummyMock = DummyMock();
                mocks.write(dummyMock);
                return DummyService(dummyDependency: dummyMock);
              },
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  steps: [],
                ),
                UnitScenario(
                  description: 'Saving a bad dummy should fail',
                  steps: [],
                ),
              ],
            ),
          ],
        );
}
```

### 🐾 Steps

---

Now comes the good part. For each scenario, we may define `steps`. We have access to `Given`, `When`, `Then`, `And` and `But`. All of these steps do basically the same thing in the background, but by using them correctly, you learn to plan, work out and execute your tests in an intuitive and proper BDD way.

Each step requires a description and a callback. The callback for the `UnitTests` looks as follows and grants access to the following parameters:

```dart
/// Callback used to provide the necessary tools to execute an [UnitStep].
typedef UnitStepCallback<SUT, Example extends UnitExample?> = FutureOr<void> Function(
  SUT systemUnderTest,
  UnitLog log,
  UnitBox box,
  UnitMocks mocks, [
  Example? example,
]);
```

- `SUT systemUnderTest`
  - The class that we specified earlier in the `UnitScenario` that resembles the unit that we want to test.
- `Log log`
  - Class that allows for subtle logging of steps information in your tests.
- `UnitBox box`
  - This box is basically a map that may be used to write and read values that need to persist throughout a series of steps inside a `UnitScenario`. Any value that you `box.write(key, value)` will be retrievable in all `UnitStep`'s after that or until removed or until all steps have been executed. Reading a value with box.`read(key)` will automatically cast it to the `Type` that you specify. So reading an `int` like this → `final int value = box.read(myIntValue)` would automatically cast it to an `int` (🆒).

    Using the box may look like this:

      ```dart
      [
        Given(
          'This is an example for the UnitBox',
          (systemUnderTest, log, box, mocks, [example]) {
            box.write('isExample', true);
          },
        ),
        When(
          'we write some values',
          (systemUnderTest, log, box, mocks, [example]) {
            box.write('exampleValue', 1);
            box.write('mood', 'happy');
          },
        ),
        Then(
          'all the values should be accessible up until the last step.',
          (systemUnderTest, log, box, mocks, [example]) {
            final bool isExample = box.read('isExample');
            final int exampleValue = box.read('exampleValue');
            final bool mood = box.read('mood');
            expect(isExample, true);
            expect(exampleValue, 1);
            expect(mood, 'happy');
          },
        ),
      ]
      ```

- `UnitMocks mocks`
  - Alos a box that exists and persists throughout your entire `UnitTest`, `UnitFeature` and/or `UnitScenario`. You may have optionally used this box to store mocks that your `systemUnderTest` needs so you may later retrieve them to stub methods to your liking.
- `UnitExample? example`
  - Optional ‘Scenario Outline’ examples that may have been specified inside a `UnitScenario` like this:

      ```
      UnitScenario(
        description: 'Saving a good dummy should succeed',
        examples: [
          const UnitExample(values: [1]),
          const UnitExample(values: [5]),
          const UnitExample(values: [10]),
        ],
      )
      ```

    This `UnitScenario` will now run 3 times, once for each `UnitExample`. You may access the `example` in the following way:

      ```dart
      Given(
        'I access the example value',
        (systemUnderTest, log, box, mocks, [example]) {
          final int exampleValue = example!.firstValue();
        },
      )
      ```

      <aside>
      💡 *Be sure to make your declaration type safe so the `firstValue()` helper method can `cast` the value to whatever type your specify, use with caution!*

      </aside>


### 🐾 Steps Implementation

Combining all that information will allow us to finalise and set up the success scenario like this:

```dart
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          features: [
            UnitFeature<DummyService>(
              description: 'Saving of dummies',
              systemUnderTest: (mocks) {
                final dummyMock = DummyMock();
                mocks.write(dummyMock);
                return DummyService(dummyDependency: dummyMock);
              },
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  steps: [
                    Given(
                      'The dummy service is initialised',
                      (systemUnderTest, log, box, mocks, [_]) {
												mocks.read(DummyMock).stubWhatever();
                        // TODO(you): Initialise service
                      },
                    ),
                    When(
                      'We call the dummy service with dummy info',
                      (systemUnderTest, log, box, mocks, [example]) {
                        // TODO(you): Call dummy service with dummy info
                      },
                    ),
                    Then(
                      'It should succeed',
                      (systemUnderTest, log, box, mocks, [example]) {
                        // TODO(you): Verify success
                      },
                    ),
                  ],
                ),
                UnitScenario(
                  description: 'Saving a bad dummy should fail',
                  steps: [],
                ),
              ],
            ),
          ],
        );
}
```

### **🏆 Bonus UnitSteps**

---

Because not everybody wants to write tests the same way we also created these combined step classes to allow for creating the same kind of unit tests, but with less steps.

- `GivenWhenThen`
  - For when you can’t be bothered to create and use the separate step functionality regarding the ‘Given’, ‘When’ and ‘Then’ steps. This allows you to write the entire test in one step.
- `WhenThen`
  - For when you can’t be bothered to create and use the separate step functionality regarding the ‘When’ and ‘Then’ steps. This allows you to combine both steps into one.
- `Should`
  - For when you feel like using steps is not your style. This step defines the entire test in one ‘Should’ sentence.

# ⚡️ Almost there!

While this may perfectly fit our testing needs there are a couple functionalities at our disposal that give our tests extra power.

### 🏗 setUpOnce, setUpEach, tearDownOnce, tearDownEach

---

Each class has access to these methods and will run them in sort of the same way:

- `setUpEach` - will run at the START of EACH `UnitScenario` under the chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `tearDownEach` - will run at the END of EACH `UnitScenario` under the chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `setUpOnce` - will run ONCE at the START of chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).
- `tearDownOnce` - will run ONCE at the END of chosen class (may be specified in `UnitTest`, `UnitFeature` or `UnitScenario` itself).

<aside>
💡 So a good way to remember which method does what is that all the `each` methods will run per `UnitScenario` / `UnitExample` (**this** is important to realise!) **under the defining class that holds the method** and all the `once` methods will run **once in the defining class that holds the method**.

</aside>

Using the methods may look a bit like this:

```dart
class DummyUnitTest extends UnitTest {
  DummyUnitTest()
      : super(
          description: 'All unit tests regarding dummies',
          setUpOnce: (mocks, systemUnderTest) async {
            await AppSetup.initialise(); // Runs once at the start of this test.
          },
          setUpEach: (mocks, systemUnderTest) async {
            systemUnderTest.reset();
          },
          tearDownOnce: (mocks, systemUnderTest) async {
            await AppSetup.dispose(); // Runs once at the end of this test.
          },
          features: [
            UnitFeature<DummyService>(
              description: 'Saving of dummies',
              setUpEach: (mocks, systemUnderTest) {
                // TODO(you): Do something
              },
              systemUnderTest: (mocks) {
                final dummyMock = DummyMock();
                mocks.write(dummyMock);
                return DummyService(dummyDependency: dummyMock);
              },
              scenarios: [
                UnitScenario(
                  description: 'Saving a good dummy should succeed',
                  tearDownEach: (mocks, systemUnderTest) {
                    // TODO(you): Do something
                  },
                  examples: [
                    const UnitExample(values: [1]),
                    const UnitExample(values: [5]),
                    const UnitExample(values: [10]),
                  ],
                  steps: [
                    Given(
                      'I access the example value',
                      (systemUnderTest, log, box, mocks, [example]) {
                        final int exampleValue = example!.firstValue();
                      },
                    )
                  ],
                ),
                UnitScenario(
                  description: 'Saving a bad dummy should fail',
                  steps: [],
                ),
              ],
            ),
          ],
        );
}
```

# ✅ Success!

Now to run these tests all you have to do is add the `DummyUnitTests` to your main test function, hit run and pray for success.

```dart
void main() {
  DummyUnitTests().test();
}
```
