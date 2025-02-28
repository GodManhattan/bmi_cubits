import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'calculator_state.dart';

class BmiCalculatorCubit extends Cubit<BmiCalculatorState> {
  BmiCalculatorCubit() : super(CalculatorInitial());

  /// Returns the current active state if it exists, otherwise returns a default `CalculatorActive` state.
  CalculatorActive get _activeState {
    final currentState = state; // Get the current state of the Cubit.
    if (currentState is CalculatorActive) {
      return currentState; // If the current state is `InputActive`, return it.
    }
    return const CalculatorActive(); // Otherwise, return a default `InputActive` instance.
  }

  /// Emits a new `InputActive` state with updated values and checks validation.
  /// It ensures that only modified fields are updated while keeping others unchanged.
  void _emitActiveState({
    double? heightFeet,
    double? heightInches,
    double? weight,
    String? heightError,
    String? weightError,
  }) {
    final currentState = _activeState; // Retrieve the current active state.

    // Create a new state by copying the current state and updating only the given values.
    final newState = currentState.copyWith(
      heightFeet: heightFeet,
      heightInches: heightInches,
      weight: weight,
      heightError: heightError,
      weightError: weightError,
    );

    final isValid = _validateInputs(newState); // Validate the new state.

    emit(newState.copyWith(
        isValid: isValid)); // Emit the updated state with validation result.
  }

  /// Validates the input values (height and weight) and ensures there are no errors.
  /// Returns `true` if all validations pass, otherwise returns `false`.
  bool _validateInputs(CalculatorActive state) {
    // Validate height: Must be between 1 and 8 feet, and inches must be between 0 and 11.
    final hasValidHeight = state.heightFeet != null &&
        state.heightFeet! >= 1 &&
        state.heightFeet! <= 8 &&
        (state.heightInches == null ||
            (state.heightInches! >= 0 && state.heightInches! < 12));

    // Validate weight: Must be between 22 and 1102 pounds.
    final hasValidWeight =
        state.weight != null && state.weight! >= 22 && state.weight! <= 450;

    // Ensure there are no error messages present.
    final hasNoErrors = state.heightError == null && state.weightError == null;

    return hasValidHeight &&
        hasValidWeight &&
        hasNoErrors; // Return validation result.
  }

  /// Updates the height in feet based on user input.
  /// This method is expected to handle conversion and validation of the input string.
  void updateHeightFeet(String value) {
    try {
      if (value.isEmpty) {
        // Handle empty input case
        _emitActiveState(
          heightFeet: null,
          heightError: "Feet is required",
        );
        return;
      }
      final feet = double.tryParse(value);

      if (feet == null) {
        _emitActiveState(
          heightError: "Invalid feet value",
        );
        return;
      }
      if (feet < 1 || feet > 8) {
        _emitActiveState(
          heightFeet: feet,
          heightError: "Height must be between 1-8 feets",
        );
        return;
      }
      _emitActiveState(
        heightFeet: feet,
        heightError: null,
      );
    } catch (e) {
      // Handle any potential errors
      emit(CalculatorError(e.toString()));
    }
  }

  /// Updates the height in inches based on user input.
  /// This method is expected to handle conversion and validation of the input string.
  void updateHeightInches(String value) {
    try {
      if (value.isEmpty) {
        _emitActiveState(
          heightInches: null,
          heightError: null, // Inches are optional
        );
        return;
      }

      final inches = double.tryParse(value);
      if (inches == null) {
        _emitActiveState(
          heightError: 'Invalid inches value',
        );
        return;
      }

      if (inches < 0 || inches >= 12) {
        _emitActiveState(
          heightInches: inches,
          heightError: 'Inches must be between 0-11',
        );
        return;
      }

      _emitActiveState(
        heightInches: inches,
        heightError: null,
      );
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  /// Updates the weight based on user input.
  /// This method is expected to handle conversion and validation of the input string.
  void updateWeight(String value) {
    try {
      if (value.isEmpty) {
        _emitActiveState(
          weight: null,
          weightError: 'Weight is required',
        );
        return;
      }

      final weight = double.tryParse(value);
      if (weight == null) {
        _emitActiveState(
          weightError: 'Invalid weight value',
        );
        return;
      }

      if (weight < 22 || weight > 1102) {
        _emitActiveState(
          weight: weight,
          weightError: 'Weight must be between 22-450 lbs',
        );
        return;
      }

      _emitActiveState(
        weight: weight,
        weightError: null,
      );
    } catch (e) {
      emit(CalculatorError(e.toString()));
    }
  }

  double? calculateBMI() {
    final currentState = state;
    if (currentState is! CalculatorActive || !currentState.isValid) {
      return null;
    }

    final totalInches = currentState.totalHeightInInches;
    final weight = currentState.weight;

    if (totalInches == null || weight == null) {
      return null;
    }

    // Imperial BMI formula: (weight / height²) * 703
    return (weight / (totalInches * totalInches)) * 703;
  }

  void reset() {
    emit(const CalculatorInitial());
  }
}
