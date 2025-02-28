import 'package:bmi_cubits/cubits/calculator_cubit/calculator_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('InputCubit', () {
    late BmiCalculatorCubit inputCubit;

    setUp(() {
      inputCubit = BmiCalculatorCubit();
    });

    tearDown(() {
      inputCubit.close();
    });

    test('initial state is InputInitial', () {
      expect(inputCubit.state, isA<CalculatorInitial>());
    });

    group('updateHeightFeet', () {
      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when feet is empty',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightFeet(''),
        expect: () => [
          isA<CalculatorActive>().having(
            (state) => state.heightError,
            'heightError',
            'Feet is required',
          ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when feet is invalid number',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightFeet('abc'),
        expect: () => [
          isA<CalculatorActive>().having(
            (state) => state.heightError,
            'heightError',
            'Invalid feet value',
          ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when feet is less than 1',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightFeet('0.5'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightFeet, 'heightFeet', 0.5)
              .having(
                (state) => state.heightError,
                'heightError',
                'Height must be between 1-8 feets',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when feet is greater than 8',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightFeet('9'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightFeet, 'heightFeet', 9.0)
              .having(
                (state) => state.heightError,
                'heightError',
                'Height must be between 1-8 feets',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits valid state when feet is valid',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightFeet('5'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightFeet, 'heightFeet', 5.0)
              .having((state) => state.heightError, 'heightError', null),
        ],
      );
    });

    group('updateHeightInches', () {
      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'allows empty inches',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightInches(''),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightInches, 'heightInches', null)
              .having((state) => state.heightError, 'heightError', null),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when inches is invalid number',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightInches('abc'),
        expect: () => [
          isA<CalculatorActive>().having(
            (state) => state.heightError,
            'heightError',
            'Invalid inches value',
          ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when inches is negative',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightInches('-1'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightInches, 'heightInches', -1.0)
              .having(
                (state) => state.heightError,
                'heightError',
                'Inches must be between 0-11',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when inches is 12 or greater',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightInches('12'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightInches, 'heightInches', 12.0)
              .having(
                (state) => state.heightError,
                'heightError',
                'Inches must be between 0-11',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits valid state when inches is valid',
        build: () => inputCubit,
        act: (cubit) => cubit.updateHeightInches('11'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.heightInches, 'heightInches', 11.0)
              .having((state) => state.heightError, 'heightError', null),
        ],
      );
    });

    group('updateWeight', () {
      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when weight is empty',
        build: () => inputCubit,
        act: (cubit) => cubit.updateWeight(''),
        expect: () => [
          isA<CalculatorActive>().having(
            (state) => state.weightError,
            'weightError',
            'Weight is required',
          ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when weight is invalid number',
        build: () => inputCubit,
        act: (cubit) => cubit.updateWeight('abc'),
        expect: () => [
          isA<CalculatorActive>().having(
            (state) => state.weightError,
            'weightError',
            'Invalid weight value',
          ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when weight is less than 22',
        build: () => inputCubit,
        act: (cubit) => cubit.updateWeight('21'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.weight, 'weight', 21.0)
              .having(
                (state) => state.weightError,
                'weightError',
                'Weight must be between 22-1102 lbs',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits error state when weight is greater than 1102',
        build: () => inputCubit,
        act: (cubit) => cubit.updateWeight('1103'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.weight, 'weight', 1103.0)
              .having(
                (state) => state.weightError,
                'weightError',
                'Weight must be between 22-1102 lbs',
              ),
        ],
      );

      blocTest<BmiCalculatorCubit, BmiCalculatorState>(
        'emits valid state when weight is valid',
        build: () => inputCubit,
        act: (cubit) => cubit.updateWeight('150'),
        expect: () => [
          isA<CalculatorActive>()
              .having((state) => state.weight, 'weight', 150.0)
              .having((state) => state.weightError, 'weightError', null),
        ],
      );
    });

    group('calculateBMI', () {
      test('returns null when state is not InputActive', () {
        expect(inputCubit.calculateBMI(), isNull);
      });

      test('returns null when inputs are invalid', () {
        inputCubit.updateHeightFeet('5');
        inputCubit.updateHeightInches('10');
        // Weight missing
        expect(inputCubit.calculateBMI(), isNull);
      });

      test('calculates BMI correctly with valid inputs', () {
        // Set height to 5'10" (70 inches) and weight to 150 lbs
        inputCubit.updateHeightFeet('5');
        inputCubit.updateHeightInches('10');
        inputCubit.updateWeight('150');

        // BMI = (150 / (70 * 70)) * 703 ≈ 21.5
        final bmi = inputCubit.calculateBMI();
        expect(bmi, closeTo(21.5, 0.1));
      });
    });

    test('reset returns to initial state', () {
      inputCubit.updateHeightFeet('5');
      inputCubit.updateHeightInches('10');
      inputCubit.updateWeight('150');

      inputCubit.reset();

      expect(inputCubit.state, isA<CalculatorInitial>());
    });

    test('totalHeightInInches calculates correctly', () {
      inputCubit.updateHeightFeet('5');
      inputCubit.updateHeightInches('10');

      final state = inputCubit.state as CalculatorActive;
      expect(state.totalHeightInInches, equals(70));
    });
  });
}
