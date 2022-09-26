import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/gherkin_unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class IncrementModelCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel, UnitExample> {
  IncrementModelCounterScenario()
      : super(
          description: 'Increment the modelCounter',
          systemUnderTest: (_) => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [5]),
            const UnitExample(values: [10]),
          ],
          steps: [
            Given(
              'The counter is at 0',
              (systemUnderTest, log, box, mocks, [example]) {
                systemUnderTest.reset();
                expect(systemUnderTest.modelCounter, 0);
              },
            ),
            When(
              'I increment the counter',
              (systemUnderTest, log, box, mocks, [example]) {
                final int nrOfIncrements = example.firstValue();
                log.value(nrOfIncrements, 'Number of increments');
                for (int increment = 0;
                    increment < nrOfIncrements;
                    increment++) {
                  systemUnderTest.incrementModelCounter();
                }
                box.write('nrOfIncrements', nrOfIncrements);
              },
            ),
            Then(
              'We expect the modelCounter to have the value of the increments',
              (systemUnderTest, log, box, mocks, [example]) {
                final int nrOfIncrements = box.read('nrOfIncrements');
                expect(systemUnderTest.modelCounter, nrOfIncrements);
                log.success();
              },
            ),
          ],
        );
}
