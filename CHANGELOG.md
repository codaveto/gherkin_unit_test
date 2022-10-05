## 0.0.4+7

* Improved example toString again

## 0.0.4+6

* Improved example toString

## 0.0.4+5

* Removed unused UnitExample.isLastExample 

## 0.0.4+4

* Removed nullability from the `systemUnderTest` inside a `UnitScenario`.

## 0.0.4+3

* Update readme.

## 0.0.4+2

* Update readme.

## 0.0.4+1

* Updated the `UnitScenario`'s `TestGroupFunction`'s with the proper `SUT` generic.

## 0.0.4

* **✨ New:** Added the option to add a `systemUnderTest` from higher up the tree (e.g. `UnitFeature` and `UnitTest`).
* **⚠️ Breaking:** Added the `UnitMocks` object that gets passed around from initialising your `systemUnderTest` until your last `UnitStep` to facilitate better mocks integration.
* **⚠️ Breaking:** The `systemUnderTest` will now persist through all `UnitStep`s and `UnitExample`s of a `UnitScenario`.
* **⚠️ Breaking:** The `systemUnderTest` may now also be defined inside a `UnitFeature` or `UnitTest` and will cascade down to a `UnitScenario`. If a child has a new `systemUnderTest` defined it will use that instead.
* **⚠️ Breaking:** The `systemUnderTest` method of our main classes (`UnitTest`, `UnitFeature` or `UnitScenario`) will always be called before any other method inside that class.
* **⚠️ Breaking:** All set up methods (`setUpEach`, `setUpOnce`, `tearDownEach` and `tearDownOnce`) inside all parent classes (`UnitTest`, `UnitFeature` and `UnitScenario`) will now have access to the new `UnitMocks` object, as well as any `systemUnderTest` you might have initialised in one of those classes.

## 0.0.3

* **⚠️ Breaking:** Replaces the `result` parameter (now `box`) of the `UnitStepCallback` with an instance of `UnitBox`. This will allow you to save multiple persistent values throughout a series of steps inside the `box` instead of passing around a maximum of one single value as a `result` through multiple steps.
* **⚠️ Breaking:** Removed the recently introduces extension methods for cast a result since `result` has now been replaces with the new `UnitBox` which has this functionality built in.

## 0.0.2+1

* Added `asType` and `asNullableType` extension methods for easier usage of an `UnitStep`'s result.

## 0.0.2

* **⚠️ Breaking:** Added generic argument to scenario for easier example usage.

## 0.0.1+7

* Remove `required` from the `UnitExample.values` field.

## 0.0.1+6

* Updated info icon.

## 0.0.1+5

* Update required descriptions to nullable for more flexibility.

## 0.0.1+4

* **🐛️ Bugfix:** Fixed logging where logging would only appear if examples were not empty.

## 0.0.1+2

* Update test project.

## 0.0.1+2

* Update readme

## 0.0.1+1

* **✨ New:** Added steps `WhenThen`, `GivenWhenThen` and `Should`.
* Added example project with 100% test coverage tests created using this package.

## 0.0.1

* Update readme.

## 0.0.1

* Initial release.
