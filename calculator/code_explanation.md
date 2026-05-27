# Simple Calculator Presentation Guide

Use this guide to explain your Flutter calculator code clearly to your lecturer. It uses plain English but specifically points out the Dart concepts your lecturer will want to hear.

---

## 1. The Setup (Imports & Main)
```dart
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());
```
**How to explain it:**
*   **`dart:math`**: We import this core library just so we can use the `sqrt()` function for square roots.
*   **`material.dart`**: This gives us all the pre-built Google design tools (like buttons and text).
*   **`=>` (Arrow Function)**: This is Dart's shortcut for a function that only has one line of code.
*   **`main()`**: The starting line of the app. It just says "run the app using the `MyApp` widget."

---

## 2. The App Structure
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) { ... }
}
```
**How to explain it:**
*   **`extends` (Inheritance)**: `MyApp` inherits from `StatelessWidget`. It is "stateless" because the overall theme and title never change once the app starts.
*   **`const` and `super.key` (Constructors)**: This is the class constructor. Using `const` tells Flutter this part won't change, which saves memory. `super.key` passes an ID up to the parent class.
*   **`@override`**: This tells Dart, "I am intentionally replacing the default `build` method with my own custom one."

---

## 3. The Calculator Screen
```dart
class CalculatorPage extends StatefulWidget { ... }
class _CalculatorPageState extends State<CalculatorPage> { ... }
```
**How to explain it:**
*   **`StatefulWidget`**: The calculator screen *must* be stateful because the numbers on the screen change every time you press a button. 
*   **`_` (Private Classes)**: The underscore in `_CalculatorPageState` makes the class private, so it can only be used in this file.
*   **`<CalculatorPage>` (Generics)**: This tells Dart that this specific state strictly belongs to the `CalculatorPage`.

---

## 4. The Brain (Variables)
```dart
String display = '0';
double firstOperand = 0;
String operator = '';
bool clearNext = false;
```
**How to explain it:**
This is the calculator's memory:
*   `display`: The text currently showing on the screen.
*   `firstOperand`: The first number you typed before hitting `+`, `-`, etc.
*   `operator`: Remembers if you hit `+`, `-`, `×`, or `÷`.
*   `clearNext`: A true/false switch. If true, the screen clears when you type the next number.

---

## 5. The Logic (buttonPressed function)
```dart
void buttonPressed(String btnText) {
  setState(() { ... });
}
```
**How to explain it:**
*   **`setState()`**: This is the most important part! Whenever a button is pressed, we do the math, and then call `setState()`. This yells at Flutter: *"The memory changed! Redraw the screen!"*

**How the math works inside it:**
*   **Clear (`C`)**: Sets everything back to zero.
*   **Backspace (`⌫`)**: Uses a **Ternary Operator** (`condition ? true : false`) to chop off the last letter of the string.
*   **Square/Root (`x²`, `√`)**: Turns the string into a decimal (`double`), does the math, and turns it back into a string to show on screen.
*   **Math (`+`, `-`, etc.)**: Saves the first number and the symbol, then waits for the second number.
*   **Equals (`=`)**: Grabs the second number, looks at the saved symbol, does the final math, and shows the result.

---

## 6. The UI (What you see)
```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded( ... Text(display) ... ), // The Screen
          GridView.builder( ... )            // The Buttons
        ]
```
**How to explain it:**
*   **`Scaffold`**: The blank canvas for the screen.
*   **`Column`**: Stacks our UI vertically. It has two main pieces: The text display at the top, and the buttons at the bottom.
*   **`Expanded`**: Forces the text display to stretch and fill all the empty space at the top.
*   **`GridView.builder`**: Instead of manually coding 20 separate buttons, we give Flutter a list of symbols (`['1', '2', '+', ...]`) and tell it to automatically build a 4-column grid. When a button is tapped, it triggers our `buttonPressed` logic using an anonymous arrow function.

---

### 🎤 Quick 30-Second Presentation Summary
*"My app is built with Flutter and Dart. It uses a `StatefulWidget` because the display needs to change when buttons are pressed. The code uses object-oriented Dart concepts like Constructors, Inheritance, and `@override`. The UI is built using a `Column` that stacks an `Expanded` text box on top of a `GridView` of buttons. All the logic is handled by a single `buttonPressed` function that updates variables and calls `setState()` to instantly refresh the screen."*
