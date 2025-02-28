part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  @override
  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {
  @override
  List<Object> get props => [];
}

class HistoryLoaded extends HistoryState {
  final List<BmiRecord> records;

  const HistoryLoaded(this.records);

  @override
  List<Object?> get props => [records];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Model class for BMI records
class BmiRecord extends Equatable {
  final String id;
  final DateTime dateTime;
  final double bmiValue;
  final int heightFeet;
  final int heightInches;
  final int weight;
  final String category;

  const BmiRecord({
    required this.id,
    required this.dateTime,
    required this.bmiValue,
    required this.heightFeet,
    required this.heightInches,
    required this.weight,
    required this.category,
  });

  // Convert to and from JSON for storage
  factory BmiRecord.fromJson(Map<String, dynamic> json) {
    return BmiRecord(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      bmiValue: json['bmiValue'],
      heightFeet: json['heightFeet'],
      heightInches: json['heightInches'],
      weight: json['weight'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'bmiValue': bmiValue,
      'heightFeet': heightFeet,
      'heightInches': heightInches,
      'weight': weight,
      'category': category,
    };
  }

  @override
  List<Object?> get props =>
      [id, dateTime, bmiValue, heightFeet, heightInches, weight, category];
}
