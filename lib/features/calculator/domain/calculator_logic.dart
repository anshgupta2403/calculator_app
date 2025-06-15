import 'package:math_expressions/math_expressions.dart';

class CalculatorLogic {
  final List<String> operators = ['+', '-', '×', '÷'];

  bool isValidExpression(String expr) {
    if (expr.isEmpty) return false;
    String last = expr[expr.length - 1];
    if (operators.contains(last) || last == '.') return false;
    return true;
  }

  String getLastNumber(String expr) {
    String number = '';
    for (int i = expr.length - 1; i >= 0; i--) {
      if (operators.contains(expr[i])) break;
      number = expr[i] + number;
    }
    return number;
  }

  String evaluate(String expr) {
    try {
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }
}
