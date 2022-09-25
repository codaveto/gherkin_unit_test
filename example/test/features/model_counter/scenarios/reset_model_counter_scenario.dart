import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class ResetModelCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel, UnitExample> {
  ResetModelCounterScenario()
      : super(
          description: 'Reset the modelCounter',
          systemUnderTest: () => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [3]),
          ],
          steps: [
            Given(
              'The modelCounter has been incremented',
              (systemUnderTest, log, box, [example]) {
                systemUnderTest.reset();
                final int nrOfIncrements = example.firstValue();
                for (int increment = 0;
                    increment < nrOfIncrements;
                    increment++) {
                  systemUnderTest.incrementModelCounter();
                }
                expect(systemUnderTest.modelCounter, nrOfIncrements);
              },
            ),
            WhenThen(
              'I call the reset method then the modelCounter should be 0',
              (systemUnderTest, log, box, [example]) {
                systemUnderTest.reset();
                expect(systemUnderTest.modelCounter, 0);
              },
            ),
          ],
        );
}
