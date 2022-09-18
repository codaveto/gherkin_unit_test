import 'package:example/gherkin_unit_test_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gherkin Unit Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GherkinUnitTestView(),
    );
  }
}
