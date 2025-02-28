import 'package:bmi_cubits/cubits/calculator_cubit/calculator_cubit.dart';
import 'package:bmi_cubits/cubits/history_cubit/history_cubit.dart';
import 'package:bmi_cubits/screens/bmi_calculator_screen.dart';
import 'package:bmi_cubits/screens/history_data_screen.dart';
import 'package:bmi_cubits/screens/information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //navigation bar
  int _currentPageIndex = 0;

  // Create cubits
  late final BmiCalculatorCubit _calculatorCubit;
  late final HistoryCubit _historyCubit;

  @override
  void initState() {
    super.initState();
    _calculatorCubit = BmiCalculatorCubit();
    _historyCubit = HistoryCubit();
  }

  @override
  void dispose() {
    _calculatorCubit.close();
    _historyCubit.close();
    super.dispose();
  }

  // Create screens with their respective cubits
  List<Widget> get _screens => [
        // Calculator screen with both cubits
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _calculatorCubit),
            BlocProvider.value(value: _historyCubit),
          ],
          child: const BmiCalculatorScreen(),
        ),
        BlocProvider.value(
          value: _historyCubit,
          child: const HistoryDataScreen(),
        ),
        const InformationScreen(),
      ];

  void _onDestinationSelection(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.analytics_sharp), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.perm_data_setting_outlined), label: "History"),
            NavigationDestination(icon: Icon(Icons.info), label: "Information"),
          ],
          selectedIndex: _currentPageIndex,
          onDestinationSelected: _onDestinationSelection,
        ),
        body: SafeArea(child: _screens[_currentPageIndex]),
      ),
    );
  }
}
