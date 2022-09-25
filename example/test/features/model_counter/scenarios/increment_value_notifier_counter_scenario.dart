import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/gherkin_unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class IncrementValueNotifierCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel, UnitExample> {
  IncrementValueNotifierCounterScenario()
      : super(
          description: 'Increment the ValueNotifier counter',
          systemUnderTest: () => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [5]),
            const UnitExample(values: [10]),
          ],
          steps: [
            Given(
              'The counter is at 0',
              (systemUnderTest, log, box, [example]) {
                systemUnderTest.reset();
                expect(systemUnderTest.valueListenableCounter.value, 0);
              },
            ),
            When(
              'I increment the counter',
              (systemUnderTest, log, box, [example]) {
                final int nrOfIncrements = example.firstValue();
                log.value(nrOfIncrements, 'Number of increments');
                for (int increment = 0;
                    increment < nrOfIncrements;
                    increment++) {
                  systemUnderTest.incrementValueNotifierCounter();
                }
                box.write('nrOfIncrements', nrOfIncrements);
              },
            ),
            Then(
              'We expect the ValueNotifier counter to have the value of the increments',
              (systemUnderTest, log, box, [example]) {
                final int nrOfIncrements = box.read('nrOfIncrements');
                expect(systemUnderTest.valueListenableCounter.value,
                    nrOfIncrements);
                log.success();
              },
            ),
          ],
        );
}
