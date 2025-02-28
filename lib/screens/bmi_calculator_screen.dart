import 'package:bmi_cubits/cubits/calculator_cubit/calculator_cubit.dart';
import 'package:bmi_cubits/cubits/history_cubit/history_cubit.dart';
import 'package:bmi_cubits/screens/widgets/bmi_gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreen();
}

class _BmiCalculatorScreen extends State<BmiCalculatorScreen> {
  double _currentHeightSliderValue = 60;
  double _currentWeightSliderValue = 150;

  String getBmiCategory(double? bmi) {
    if (bmi == null) return "Enter values";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    if (bmi < 40) return "Obese";
    return "Extremely Obese";
  }

  @override
  void initState() {
    super.initState();
    // Set initial values
    // Initialize cubit with default values
    final (feet, inches) =
        convertInchesToFeetAndInches(_currentHeightSliderValue.toInt());
    context.read<BmiCalculatorCubit>().updateHeightFeet(feet.toString());
    context.read<BmiCalculatorCubit>().updateHeightInches(inches.toString());
    context
        .read<BmiCalculatorCubit>()
        .updateWeight(_currentWeightSliderValue.toString());
  }

  void onSliderHeightChanged(double value) {
    setState(() {
      _currentHeightSliderValue = value;
      // Update cubit with new height
      final (feet, inches) = convertInchesToFeetAndInches(value.toInt());
      context.read<BmiCalculatorCubit>().updateHeightFeet(feet.toString());
      context.read<BmiCalculatorCubit>().updateHeightInches(inches.toString());
    });
  }

  void onSliderWeightChanged(double value) {
    setState(() {
      _currentWeightSliderValue = value;
      // Update cubit with new weight
      context.read<BmiCalculatorCubit>().updateWeight(value.toString());
    });
  }

  (int feet, int inches) convertInchesToFeetAndInches(int totalInches) {
    // Get the whole number of feet
    int feet = (totalInches / 12).floor();

    // Get the remaining inches
    int inches = (totalInches % 12).round();

    // Handle case where inches equals 12
    if (inches == 12) {
      feet += 1;
      inches = 0;
    }

    return (feet, inches);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BmiCalculatorCubit, BmiCalculatorState>(
      builder: (context, state) {
        // Get current values for display
        final (feet, inches) =
            convertInchesToFeetAndInches(_currentHeightSliderValue.toInt());
        final weight = _currentWeightSliderValue.toInt();
        // Calculate BMI if state is valid
        double? bmiValue;
        if (state is CalculatorActive && state.isValid) {
          bmiValue = context.read<BmiCalculatorCubit>().calculateBMI();
        }

        return Column(
          children: [
            // Error messages from state
            if (state is CalculatorActive &&
                (state.heightError != null || state.weightError != null))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state.heightError != null)
                      Text(
                        state.heightError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (state.weightError != null)
                      Text(
                        state.weightError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 20),
                              child: SizedBox(
                                height: 30,
                                width: 50,
                                child: Text(
                                  '$feet\' Ft',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: 30,
                                width: 50,
                                child: Text(
                                  '$inches" in',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: _currentHeightSliderValue.toDouble(),
                          max: 100,
                          min: 40,
                          onChanged: onSliderHeightChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        child: SizedBox(
                          height: 30,
                          width: 60,
                          child: Text(
                            '$weight lb',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Slider(
                          value: _currentWeightSliderValue.toDouble(),
                          max: 450,
                          min: 40,
                          onChanged: onSliderWeightChanged,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            // Pass the BMI value to the gauge
            BMIGauge(bmiValue: bmiValue),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentHeightSliderValue = 60; // 5 feet
                    _currentWeightSliderValue = 150;
                  });
                  context.read<BmiCalculatorCubit>().reset();
                  // Re-initialize cubit with default values
                  final (feet, inches) = convertInchesToFeetAndInches(60);
                  context
                      .read<BmiCalculatorCubit>()
                      .updateHeightFeet(feet.toString());
                  context
                      .read<BmiCalculatorCubit>()
                      .updateHeightInches(inches.toString());
                  context.read<BmiCalculatorCubit>().updateWeight('150');
                },
                child: const Text('Reset'),
              ),
            ),
            if (bmiValue != null)
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Save the BMI result to history
                    context.read<HistoryCubit>().addRecord(
                          bmiValue: bmiValue,
                          heightFeet: feet.toDouble(),
                          heightInches: inches.toDouble(),
                          weight: weight.toDouble(),
                          category: getBmiCategory(bmiValue),
                        );

                    // Show confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('BMI record saved')),
                    );
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save Result'),
                ),
              ),
          ],
        );
      },
    );
  }
}
