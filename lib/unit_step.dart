part of 'unit_test.dart';

/// Callback used to provide the necessary tools to execute a [UnitStep].
typedef UnitStepCallback<SUT, Example extends UnitExample?> = FutureOr<dynamic>
    Function(
  SUT systemUnderTest,
  UnitLog log, [
  Example? example,
  Object? result,
]);

/// Used to represents a step inside a [UnitScenario].
abstract class UnitStep<SUT, Example extends UnitExample?> {
  UnitStep({
    required String description,
    required UnitStepCallback<SUT, Example> step,
  })  : _description = description,
        _step = step;

  /// High-level description of the [UnitStep].
  final String _description;

  /// Async callback function that provides a [WidgetTester] and possible one of [UnitScenario._examples].
  final UnitStepCallback<SUT, Example> _step;

  /// Runs all code defined in a specific [UnitStep].
  FutureOr<Object?> test({
    required SUT systemUnderTest,
    required UnitLog log,
    Example? example,
    Object? result,
  }) async {
    debugPrint(_description);
    return await _step(
      systemUnderTest,
      log,
      example,
      result,
    );
  }
}

/// Implementation of a [UnitStep] that logs a 'Gherkin' -> 'Given' step.
class Given<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  Given(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 Given: $description',
          step: step,
        );
}

/// Implementation of a [UnitStep] that logs a 'Gherkin' -> 'And' step.
class And<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  And(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 And: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that logs a 'Gherkin' -> 'When' step.
class When<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  When(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 When: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that logs a 'Gherkin' -> 'Then' step.
class Then<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  Then(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 Then: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that logs a 'Gherkin' -> 'But' step.
class But<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  But(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 But: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that logs a 'Gherkin' -> 'Give', 'When' and 'Then' step.
class GivenWhenThen<SUT, Example extends UnitExample?>
    extends UnitStep<SUT, Example> {
  GivenWhenThen(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 Give, When and Then: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that logs a 'Gherkin' -> 'When' and 'Then' step.
class WhenThen<SUT, Example extends UnitExample?>
    extends UnitStep<SUT, Example> {
  WhenThen(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 When and Then: $description',
          step: step,
        );
}

/// Implementation of an [UnitStep] that discards the 'Gherkin' notation and tells us directly what the code should do.
class Should<SUT, Example extends UnitExample?> extends UnitStep<SUT, Example> {
  Should(String description, UnitStepCallback<SUT, Example> step)
      : super(
          description: '[UNIT-TEST] 👉 Should: $description',
          step: step,
        );
}
