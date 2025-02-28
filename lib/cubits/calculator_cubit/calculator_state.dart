part of 'calculator_cubit.dart';

// Base state class
sealed class BmiCalculatorState extends Equatable {
  const BmiCalculatorState();
}

// Initial state
class CalculatorInitial extends BmiCalculatorState {
  const CalculatorInitial();

  @override
  List<Object?> get props => [];
}

// Loading state if needed
class CalculatorLoading extends BmiCalculatorState {
  const CalculatorLoading();

  @override
  List<Object?> get props => [];
}

// Main state for input data
class CalculatorActive extends BmiCalculatorState {
  final double? heightFeet;
  final double? heightInches;
  final double? weight;
  final String? heightError;
  final String? weightError;
  final bool isValid;

  const CalculatorActive({
    this.heightFeet,
    this.heightInches,
    this.weight,
    this.heightError,
    this.weightError,
    this.isValid = false,
  });

  CalculatorActive copyWith({
    double? heightFeet,
    double? heightInches,
    double? weight,
    String? heightError,
    String? weightError,
    bool? isValid,
  }) {
    return CalculatorActive(
      heightFeet: heightFeet ?? this.heightFeet,
      heightInches: heightInches ?? this.heightInches,
      weight: weight ?? this.weight,
      heightError: heightError ?? this.heightError,
      weightError: weightError ?? this.weightError,
      isValid: isValid ?? this.isValid,
    );
  }

  /// Converts feet and inches to total inches
  double? get totalHeightInInches {
    if (heightFeet == null) return null;
    final inches = heightInches ?? 0;
    return (heightFeet! * 12) + inches;
  }

  @override
  List<Object?> get props => [
        heightFeet,
        heightInches,
        weight,
        heightError,
        weightError,
        isValid,
      ];
}

// Error state
class CalculatorError extends BmiCalculatorState {
  final String message;

  const CalculatorError(this.message);

  @override
  List<Object?> get props => [message];
}
