import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class ResetValueNotifierCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel> {
  ResetValueNotifierCounterScenario()
      : super(
          description: 'Reset the ValueNotifier',
          systemUnderTest: () => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [3]),
          ],
          steps: [
            Given(
              'The ValueNotifier has been incremented',
              (systemUnderTest, log, [example, result]) {
                systemUnderTest.reset();
                final int nrOfIncrements = example.firstValue();
                for (int increment = 0;
                    increment < nrOfIncrements;
                    increment++) {
                  systemUnderTest.incrementValueNotifierCounter();
                }
                expect(systemUnderTest.valueListenableCounter.value,
                    nrOfIncrements);
              },
            ),
            WhenThen(
              'I call the reset method then the ValueNotifier should be 0',
              (systemUnderTest, log, [example, result]) {
                systemUnderTest.reset();
                expect(systemUnderTest.valueListenableCounter.value, 0);
                log.success();
              },
            ),
          ],
        );
}
