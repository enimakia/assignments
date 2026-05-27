import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double firstOperand = 0;
  String operator = '';
  bool clearNext = false;

  void buttonPressed(String btnText) {
    setState(() {
      if (btnText == 'C') {
        display = '0';
        firstOperand = 0;
        operator = '';
      } else if (btnText == '⌫') {
        display = display.length > 1 ? display.substring(0, display.length - 1) : '0';
      } else if (btnText == '√') {
        display = sqrt(double.parse(display)).toString();
      } else if (btnText == 'x²') {
        double val = double.parse(display);
        display = (val * val).toString();
      } else if (['+', '−', '×', '÷'].contains(btnText)) {
        firstOperand = double.parse(display);
        operator = btnText;
        clearNext = true;
      } else if (btnText == '=') {
        double secondOperand = double.parse(display);
        if (operator == '+') display = (firstOperand + secondOperand).toString();
        if (operator == '−') display = (firstOperand - secondOperand).toString();
        if (operator == '×') display = (firstOperand * secondOperand).toString();
        if (operator == '÷') display = (firstOperand / secondOperand).toString();
        operator = '';
        clearNext = true;
      } else {
        if (clearNext) {
          display = btnText;
          clearNext = false;
        } else {
          display = display == '0' && btnText != '.' ? btnText : display + btnText;
        }
      }

      // Clean up trailing .0 for cleaner output
      if (display.endsWith('.0')) {
        display = display.substring(0, display.length - 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'C', '√', 'x²', '⌫',
      '7', '8', '9', '÷',
      '4', '5', '6', '×',
      '1', '2', '3', '−',
      '.', '0', '=', '+',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2, // Controls button size
            ),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => buttonPressed(buttons[index]),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    buttons[index],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
