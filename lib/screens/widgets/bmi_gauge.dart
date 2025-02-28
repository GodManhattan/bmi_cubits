import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMIGauge extends StatelessWidget {
  final double? bmiValue;
  const BMIGauge({super.key, this.bmiValue});

  // Get BMI category description
  String getBmiCategory(double? bmi) {
    if (bmi == null) return "Enter values";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    if (bmi < 40) return "Obese";
    return "Extremely Obese";
  }

  // Get color based on BMI value
  Color getBmiColor(double? bmi) {
    if (bmi == null) return Colors.grey;
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    if (bmi < 40) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      // title: GaugeTitle(text: "BMI"),
      axes: [
        RadialAxis(
          labelsPosition: ElementsPosition.outside,
          showLastLabel: true,
          minimum: 10,
          maximum: 70,
          startAngle: 180,
          endAngle: 360,
          ranges: [
            GaugeRange(
                startValue: 10,
                endValue: 18.5,
                color: Colors.blue,
                startWidth: 50,
                endWidth: 50),
            GaugeRange(
                startValue: 18.5,
                endValue: 24.9,
                color: Colors.green,
                startWidth: 50,
                endWidth: 50),
            GaugeRange(
                startValue: 24.9,
                endValue: 29.9,
                color: Colors.orange,
                startWidth: 50,
                endWidth: 50),
            GaugeRange(
                startValue: 29.9,
                endValue: 40,
                color: Colors.red,
                startWidth: 50,
                endWidth: 50),
            GaugeRange(
                startValue: 40,
                endValue: 70,
                color: Colors.purple,
                startWidth: 50,
                endWidth: 50),
          ],
          pointers: [
            NeedlePointer(
              value: bmiValue ?? 0, // Point to the calculated BMI or 0
              enableAnimation: true,
              animationDuration: 1000,
              animationType: AnimationType.easeOutBack,
            ),
          ],
          annotations: [
            GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bmiValue?.toStringAsFixed(1) ?? '--',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: getBmiColor(bmiValue),
                      ),
                    ),
                    Text(
                      getBmiCategory(bmiValue),
                      style: TextStyle(
                        fontSize: 16,
                        color: getBmiColor(bmiValue),
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.4)
          ],
        ),
      ],
    );
  }
}
