import 'package:first_app_2/button_values.dart';
import 'package:flutter/material.dart';

class Calculatorscreen extends StatefulWidget {
  const Calculatorscreen({super.key});

  @override
  State<Calculatorscreen> createState() => _CalculatorscreenState();
}

class _CalculatorscreenState extends State<Calculatorscreen> {
  @override
  String number1 = "";
  String operand = "";
  String number2 = "";

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print(screenSize);
    return Scaffold(
        body: SafeArea(
      // bottom: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  //output
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  )),
            ),
          ),
          //buttons

          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.height / 8,
                      child: buildButtons(value)),
                )
                .toList(),
          )
        ],
      ),
    ));
  }

  Widget buildButtons(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          color: getBtnColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: const BorderSide(color: Colors.white12)),
          child: InkWell(
              onTap: () => onBtnTapped(value),
              child: Center(
                  child: Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              )))),
    );
  }

  void onBtnTapped(String value) {
    if (value == Btn.clr) {
      clear();
      return;
    }
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.per) {
      converttoPercentage();
      return;
    }
    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = (num1 + num2);
        break;
      case Btn.subtract:
        result = (num1 - num2);
        break;
      case Btn.multiply:
        result = (num1 * num2);
        break;
      case Btn.divide:
        result = (num1 / num2);
        result = (result * 100000).round() / 100000;
        break;
      default:
    }
    setState(() {
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      number2 = "";
      operand = "";
    });
  }

  void converttoPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void clear() {
    number1 = "";
    number2 = "";
    operand = "";
    setState(() {});
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) {}
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) {}
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black45;
  }
}
