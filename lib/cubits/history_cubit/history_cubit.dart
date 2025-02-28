import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial()) {
    loadRecords();
  }

  // File path for storing BMI records
  Future<String> get _filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/bmi_records.json';
  }

  Future<void> loadRecords() async {
    try {
      emit(HistoryLoading());
      final file = File(await _filePath);
      if (!await file.exists()) {
        // No records yet
        emit(const HistoryLoaded([]));
        return;
      }
      final jsonString = await file.readAsString();
      final jsonList = json.decode(jsonString) as List;
      final records =
          jsonList.map((recordJson) => BmiRecord.fromJson(recordJson)).toList();
      // Sort records by date (newest first)
      records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      emit(HistoryLoaded(records));
    } catch (e) {
      emit(HistoryError('Failed to load records: $e'));
    }
  } //end of loadRecords

  // Save a new BMI record
  Future<void> addRecord({
    required double? bmiValue,
    required double heightFeet,
    required double heightInches,
    required double weight,
    required String category,
  }) async {
    // Return early if any required value is null
    if (bmiValue == null) {
      return;
    }
    try {
      // Create a new record
      final newRecord = BmiRecord(
        id: const Uuid().v4(), // Generate unique ID
        dateTime: DateTime.now(),
        bmiValue: bmiValue,
        heightFeet: heightFeet.toInt(),
        heightInches: heightInches.toInt(),
        weight: weight.toInt(),
        category: category,
      );

      // Get current records or empty list if not loaded yet
      List<BmiRecord> currentRecords = [];
      if (state is HistoryLoaded) {
        currentRecords = List.of((state as HistoryLoaded).records);
      } else {
        await loadRecords();
        if (state is HistoryLoaded) {
          currentRecords = List.of((state as HistoryLoaded).records);
        }
      }

      // Add new record
      currentRecords.insert(0, newRecord); // Add to beginning (newest first)
      // Save to file
      await _saveRecordsToFile(currentRecords);
      emit(HistoryLoaded(currentRecords));
    } catch (e) {
      emit(HistoryError('Failed to add record: $e'));
    }
  } //end of addRecords

  // Delete a record
  Future<void> deleteRecord(String id) async {
    if (state is! HistoryLoaded) return;

    try {
      final currentRecords = List.of((state as HistoryLoaded).records);
      final updatedRecords = currentRecords
          .where((record) => record.id != id)
          .toList(); // me quedo con todos los records excepto el del id que quiero eliminar

      await _saveRecordsToFile(
          updatedRecords); //guardo la lista sin el record que exclui en la lista de arriba

      emit(HistoryLoaded(updatedRecords));
    } catch (e) {
      emit(HistoryError('Failed to delete record: $e'));
    }
  } //end of deleteRecord

  // Clear all records
  Future<void> clearAllRecords() async {
    try {
      await _saveRecordsToFile([]);
      emit(const HistoryLoaded([]));
    } catch (e) {
      emit(HistoryError('Failed to clear records: $e'));
    }
  } //end of clearAllRecords

  // Helper method to save records to file
  Future<void> _saveRecordsToFile(List<BmiRecord> records) async {
    final file = File(await _filePath);
    final jsonList = records.map((record) => record.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await file.writeAsString(jsonString);
  } //end of_saveRecordsToFile
} //end of HistoryCubit
