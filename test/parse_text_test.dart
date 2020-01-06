import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class Parsed {
  final String txt;
  final double qty;
  final double sum;

  Parsed(this.txt, this.qty, this.sum);
}

Parsed parse(String rawTxt) {
  if (rawTxt == null) {
    return Parsed(null, null, null);
  }
  if (rawTxt.isEmpty) {
    return Parsed(rawTxt, null, null);
  }
  final lastColonIdx = rawTxt.lastIndexOf(':');
  if (lastColonIdx < 0) {
    return Parsed(rawTxt, null, null);
  }
  //
  final txt = rawTxt.substring(0, lastColonIdx);
  final suffix = rawTxt
      .substring(lastColonIdx + 1, rawTxt.length)
      .replaceAll(',', '.')
      .replaceAll(' ', '');
  final maybeQty = double.tryParse(suffix);
  if (maybeQty != null) {
    return Parsed(txt, maybeQty, null);
  } else if (suffix.indexOf('=') > -1) {
    final idx = suffix.indexOf('=');
    final maybeQty1 = double.tryParse(suffix.substring(0, idx));
    final maybeSum = double.tryParse(suffix.substring(idx + 1, suffix.length));
    return maybeQty1 != null && maybeSum != null
        ? Parsed(txt, maybeQty1, maybeSum)
        : Parsed(rawTxt, null, null);
  } else if (suffix.indexOf('*') > -1) {
    final idx = suffix.indexOf('*');
    final maybeQty1 = double.tryParse(suffix.substring(0, idx));
    final maybeMulty =
        double.tryParse(suffix.substring(idx + 1, suffix.length));
    return maybeQty1 != null && maybeMulty != null
        ? Parsed(txt, maybeQty1, maybeMulty * maybeQty1)
        : Parsed(rawTxt, null, null);
  } else {
    return Parsed(rawTxt, null, null);
  }
}

/// правила
/// После последнего двоеточия может быть:
/// 1. 1 число
/// 2. 2 числа
///   2.1 через =
///   2.2 через *
/// 3. ни одного числа, если непонятно как парсить
/// * неважно, точка или запятая в разделении целой и дробной
/// * ошибка парсинга любой части  - все считается текстом
void main() {
  ///---------------------------
  ///
  test('Parsing text.0001: empty str', () {
    print('> Parsing text.0001: empty str');
    {
      final raw = null;
      final txt = null;
      final qty = null;
      final sum = null;
      final rez = parse(raw);
      expect(rez.txt, equals(txt));
      expect(rez.qty, equals(qty));
      expect(rez.sum, equals(sum));
    }
    {
      final raw = '';
      final txt = '';
      final qty = null;
      final sum = null;
      final rez = parse(raw);
      expect(rez.txt, equals(txt));
      expect(rez.qty, equals(qty));
      expect(rez.sum, equals(sum));
    }
  });

  ///-----------------------------------
  ///
  test('Parsing text.1: qty & sum', () {
    print('> Parsing text.1: qty & sum');
    final raw = 'my text: 15.5 = 1550';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.2: qty & sum', () {
    print('> Parsing text.2: qty & sum');
    final raw = 'my text: 15.5 = 1550.0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.3: qty & sum', () {
    print('> Parsing text.3: qty & sum');
    final raw = 'my text: 15,5 = 1550,0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.4: qty & sum', () {
    print('> Parsing text.4: qty & sum');
    final raw = 'my text:15,5=1550,0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.5: no doubles', () {
    print('> Parsing text.5: no doubles');
    final raw = 'my text 15,5=1550,0';
    final txt = 'my text 15,5=1550,0';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.6: no doubles', () {
    print('> Parsing text.6: no doubles');
    final raw = 'my text 15,5 1550,0';
    final txt = 'my text 15,5 1550,0';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.7: no doubles', () {
    print('> Parsing text.7: no doubles');
    final raw = 'my text: 15.5 = 15-50';
    final txt = 'my text: 15.5 = 15-50';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.8: no doubles', () {
    print('> Parsing text.8: no doubles');
    final raw = 'my text: 15-5 = 1550';
    final txt = 'my text: 15-5 = 1550';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.9: qty & sum', () {
    print('> Parsing text.9: qty & sum');
    final raw = 'my text: 20 : 30 40 ::: 15.5 = 1550';
    final txt = 'my text: 20 : 30 40 ::';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.10: no doubles', () {
    print('> Parsing text.10: no doubles');
    final raw = 'my text: 15.5 = 1550:';
    final txt = 'my text: 15.5 = 1550:';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///---------------------------------------------------------------------------
  ///
  test('Parsing text.11: qty', () {
    print('> Parsing text.11: qty');
    final raw = 'my text: 15.5 ';
    final txt = 'my text';
    final qty = 15.5;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.12: qty', () {
    print('> Parsing text.12: qty');
    final raw = 'my text : 15.';
    final txt = 'my text ';
    final qty = 15.0;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.13: qty', () {
    print('> Parsing text.13: qty');
    final raw = 'my text: 15,5 ';
    final txt = 'my text';
    final qty = 15.5;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.14: qty', () {
    print('> Parsing text.14: qty');
    final raw = 'my text:15,5';
    final txt = 'my text';
    final qty = 15.5;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.15: no doubles', () {
    print('> Parsing text.15: no doubles');
    final raw = 'my text 15,5';
    final txt = 'my text 15,5';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.16: no doubles', () {
    print('> Parsing text.16: no doubles');
    final raw = 'my text 15,,5';
    final txt = 'my text 15,,5';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.17: no doubles', () {
    print('> Parsing text.17: no doubles');
    final raw = 'my text: 15-';
    final txt = 'my text: 15-';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.18: qty', () {
    print('> Parsing text.18: qty');
    final raw = 'my text: -15,5';
    final txt = 'my text';
    final qty = -15.5;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.19: qty', () {
    print('> Parsing text.19: qty');
    final raw = 'my text: 20 : 30 40 ::: -15,5';
    final txt = 'my text: 20 : 30 40 ::';
    final qty = -15.5;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.20: no doubles', () {
    print('> Parsing text.20: no doubles');
    final raw = 'my text: 15.5:';
    final txt = 'my text: 15.5:';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///---------------------------------------------------------------------------
  ///
  test('Parsing text.21: qty & sum', () {
    print('> Parsing text.21: qty & sum');
    final raw = 'my text: 15.5 * 100';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.22: qty & sum', () {
    print('> Parsing text.22: qty & sum');
    final raw = 'my text: 15.5 * 100.0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.23: qty & sum', () {
    print('> Parsing text.23: qty & sum');
    final raw = 'my text: 15,5 * 100,0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.24: qty & sum', () {
    print('> Parsing text.24: qty & sum');
    final raw = 'my text:15,5*100,0';
    final txt = 'my text';
    final qty = 15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.25: no doubles', () {
    print('> Parsing text.25: no doubles');
    final raw = 'my text 15,5*100,0';
    final txt = 'my text 15,5*100,0';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.26: no doubles', () {
    print('> Parsing text.26: no doubles');
    final raw = 'my text 15,5 100,0';
    final txt = 'my text 15,5 100,0';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.27: no doubles', () {
    print('> Parsing text.27: no doubles');
    final raw = 'my text: 15.5 * 100-0';
    final txt = 'my text: 15.5 * 100-0';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.28: no doubles', () {
    print('> Parsing text.28: no doubles');
    final raw = 'my text: 15-5 ** 100';
    final txt = 'my text: 15-5 ** 100';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.29: qty & sum', () {
    print('> Parsing text.29: qty & sum');
    final raw = 'my text: 20 : 30 40 ::: -15.5 * 100';
    final txt = 'my text: 20 : 30 40 ::';
    final qty = -15.5;
    final sum = -1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.30: no doubles', () {
    print('> Parsing text.30: no doubles');
    final raw = 'my text: 15.5 * 100:';
    final txt = 'my text: 15.5 * 100:';
    final qty = null;
    final sum = null;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });

  ///
  test('Parsing text.31: qty & sum', () {
    print('> Parsing text.31: qty & sum');
    final raw = 'my text: 20 : 30 40 ::: -15.5 * -100';
    final txt = 'my text: 20 : 30 40 ::';
    final qty = -15.5;
    final sum = 1550.0;
    final rez = parse(raw);
    expect(rez.txt, equals(txt));
    expect(rez.qty, equals(qty));
    expect(rez.sum, equals(sum));
  });
}
