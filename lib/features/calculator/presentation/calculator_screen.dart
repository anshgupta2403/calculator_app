import 'package:calculator_app/features/calculator/domain/calculator_logic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/provider/theme_provider.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '';
  String result = '';
  final operators = ['+', '-', '×', '÷'];
  final digitsAndDot = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];
  final List<dynamic> history = [];
  bool _justEvaluated = false;
  final CalculatorLogic _calcLogic = CalculatorLogic();
  late double screenWidth;
  late double screenHeight;
  late double textScale;
  bool lastExpressionContainsError = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    textScale = screenWidth / 400; // 400 is a base design width

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120 * textScale,
                padding: EdgeInsets.all(4 * textScale),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _themeIcon(
                      themeProvider,
                      isDark: false,
                      icon: Icons.wb_sunny_outlined,
                    ),
                    _themeIcon(
                      themeProvider,
                      isDark: true,
                      icon: Icons.dark_mode_outlined,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * textScale,
                      vertical: 2 * textScale,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        history[index],
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16 * textScale,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16 * textScale,
                8 * textScale,
                16 * textScale,
                4 * textScale,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  displayText,
                  style: TextStyle(
                    fontSize: (_justEvaluated ? 28 : 36) * textScale,
                    fontWeight: _justEvaluated
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (result.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16 * textScale,
                  2 * textScale,
                  16 * textScale,
                  16 * textScale,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: TextStyle(
                      fontSize: (_justEvaluated ? 36 : 28) * textScale,
                      fontWeight: _justEvaluated
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: screenHeight * 0.57,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8 * textScale,
                crossAxisSpacing: 8 * textScale,
                padding: EdgeInsets.all(8 * textScale),
                children: [
                  calculatorButton('AC'),
                  calculatorButton('C'),
                  calculatorButton('⌫'),
                  calculatorButton('÷'),
                  calculatorButton('7'),
                  calculatorButton('8'),
                  calculatorButton('9'),
                  calculatorButton('×'),
                  calculatorButton('4'),
                  calculatorButton('5'),
                  calculatorButton('6'),
                  calculatorButton('-'),
                  calculatorButton('1'),
                  calculatorButton('2'),
                  calculatorButton('3'),
                  calculatorButton('+'),
                  calculatorButton('.'),
                  calculatorButton('0'),
                  calculatorButton('='),
                  calculatorButton('%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeIcon(
    ThemeProvider themeProvider, {
    required bool isDark,
    required IconData icon,
  }) {
    return IconButton(
      onPressed: () {
        isDark ? themeProvider.setDarkTheme() : themeProvider.setLightTheme();
      },
      icon: Icon(
        icon,
        color:
            themeProvider.themeMode ==
                (isDark ? ThemeMode.dark : ThemeMode.light)
            ? Colors.orange
            : Colors.grey,
      ),
    );
  }

  Widget calculatorButton(String text) {
    return ElevatedButton(
      onPressed: () => onPressedBtn(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(24 * textScale),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24 * textScale,
          color: digitsAndDot.contains(text) ? Colors.black : Colors.orange,
        ),
      ),
    );
  }

  void onPressedBtn(String value) {
    setState(() {
      if (_justEvaluated && value != '=') {
        // Save last expression + result to history
        if (result.isNotEmpty) {
          history.insert(0, displayText);
          history.insert(0, result);
          history.insert(0, '');
        }
        _justEvaluated = false;
        if (!lastExpressionContainsError) {
          displayText = result.substring(2);
          result = '';
        } else {
          lastExpressionContainsError = false;
          displayText = '';
          result = '';
        }
      }

      if (value == 'C') {
        displayText = '';
        result = '';
      } else if (value == 'AC') {
        history.clear();
        displayText = '';
        result = '';
      } else if (value == '⌫') {
        if (displayText.isNotEmpty) {
          displayText = displayText.substring(0, displayText.length - 1);
        }
      } else if (value == '=') {
        if (_calcLogic.isValidExpression(displayText)) {
          String evalResult = _calcLogic.evaluate(displayText);
          result = evalResult;
          setState(() {
            _justEvaluated = true;
          });
        } else {
          setState(() {
            _justEvaluated = true;
          });
        }
      } else {
        if (operators.contains(value)) {
          if (displayText.isEmpty) {
            displayText += '0$value';
          } else {
            String last = displayText[displayText.length - 1];
            if (!operators.contains(last)) {
              displayText += value;
            }
          }
        } else if (value == '.') {
          String lastNumber = _calcLogic.getLastNumber(displayText);
          if (!lastNumber.contains('.')) {
            displayText += value;
          }
        } else {
          displayText += value;
        }
      }

      if (_calcLogic.isValidExpression(displayText)) {
        String eval = _calcLogic.evaluate(displayText);
        result = eval != 'Error' ? '= $eval' : '';
        if (result.contains('Infinity') || result.contains('NaN')) {
          result = '= Can\'t divide by zero';
          lastExpressionContainsError = true;
        }
      } else {
        if (result.isEmpty) {
          result = displayText.isNotEmpty
              ? '= ${displayText.substring(0, displayText.length - 1)}'
              : '';
        }
      }
    });
  }
}
