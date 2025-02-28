// history_data_screen.dart
import 'package:bmi_cubits/cubits/history_cubit/history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryDataScreen extends StatelessWidget {
  const HistoryDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyCubit = context.read<HistoryCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HistoryCubit>().loadRecords();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History'),
                  content: const Text(
                      'Are you sure you want to delete all records?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        historyCubit.clearAllRecords();
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HistoryCubit>().loadRecords();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is HistoryLoaded) {
            if (state.records.isEmpty) {
              return const Center(
                child: Text(
                  'No BMI records yet.\nCalculate and save your BMI to see history.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.records.length,
              itemBuilder: (context, index) {
                final record = state.records[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Dismissible(
                    key: Key(record.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      context.read<HistoryCubit>().deleteRecord(record.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Record deleted')),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getBmiColor(record.bmiValue),
                        child: Text(
                          record.bmiValue.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        '${record.heightFeet}\'${record.heightInches}" - ${record.weight} lbs',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${record.category} | ${DateFormat('MMM d, yyyy - h:mm a').format(record.dateTime)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Show details dialog
                        _showRecordDetails(context, record);
                      },
                    ),
                  ),
                );
              },
            );
          }

          // Default state
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  // Helper method to get color based on BMI value
  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    if (bmi < 40) return Colors.red;
    return Colors.purple;
  }

  // Show record details dialog
  void _showRecordDetails(BuildContext context, BmiRecord record) {
    // Capture the cubit reference before showing the dialog
    final historyCubit = context.read<HistoryCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('BMI: ${record.bmiValue.toStringAsFixed(1)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${record.category}'),
            const SizedBox(height: 8),
            Text(
                'Height: ${record.heightFeet.toInt()}\'${record.heightInches.toInt()}"'),
            Text('Weight: ${record.weight} lbs'),
            const SizedBox(height: 8),
            Text('Date: ${DateFormat('MMMM d, yyyy').format(record.dateTime)}'),
            Text('Time: ${DateFormat('h:mm a').format(record.dateTime)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              historyCubit.deleteRecord(record.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
