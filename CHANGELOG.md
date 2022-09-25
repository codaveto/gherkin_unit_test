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
