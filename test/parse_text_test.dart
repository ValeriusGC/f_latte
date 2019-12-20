import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class Parsed {
  static const negativeChar = '-';
  static const dividerChar = ':';
  static const equalChar = '=';
  static const multiplyChar = '*';
  static const commaChar = ',';
  static const pointChar = '.';
  static const spaceChar = ' ';
  static const emptyChar = '';
  static const invalidIdx = -1;

  final String origin;
  final String txt;
  final double qty;
  final double sum;
  final bool done;

  static Parsed parse(String origin) {
    if (origin == null) {
      return Parsed._();
    }

    // Empty or full of spaces [origin] means no [txt]
    if (origin.trim().isEmpty) {
      return Parsed._(origin: origin);
    }

    final lastColonIdx = origin.lastIndexOf(Parsed.dividerChar);

    // No delimiter - no parsing
    if (lastColonIdx < 0) {
      return Parsed._(origin: origin, txt: origin);
    }

    // empty txt means no txt
    final txt = origin.substring(0, lastColonIdx).trim();
    if (txt.isEmpty || txt.length == origin.length - 1) {
      // origin.length - 1 means that ':' is the last char
      return Parsed._(origin: origin, txt: origin);
    }

    final suffix = origin
        .substring(lastColonIdx + 1, origin.length)
        .replaceAll(commaChar, pointChar)
        .replaceAll(spaceChar, emptyChar);
    final tryQty = double.tryParse(suffix);
    if (tryQty != null) {
      return Parsed._(origin: origin, txt: txt, qty: tryQty);
    } else if (suffix.indexOf(equalChar) > invalidIdx) {
      final idx = suffix.indexOf(equalChar);
      final tryQty1 = double.tryParse(suffix.substring(0, idx));
      final trySum = double.tryParse(suffix.substring(idx + 1, suffix.length));
      return tryQty1 != null && trySum != null
          ? Parsed._(origin: origin, txt: txt, qty: tryQty1, sum: trySum)
          : Parsed._(origin: origin, txt: origin);
    } else if (suffix.indexOf(multiplyChar) > invalidIdx) {
      final idx = suffix.indexOf(multiplyChar);
      final maybeQty1 = double.tryParse(suffix.substring(0, idx));
      final tryMulti =
          double.tryParse(suffix.substring(idx + 1, suffix.length));
      return maybeQty1 != null && tryMulti != null
          ? Parsed._(
              origin: origin,
              txt: txt,
              qty: maybeQty1,
              sum: tryMulti * maybeQty1)
          : Parsed._(origin: origin, txt: origin);
    } else {
      return Parsed._(origin: origin, txt: origin);
    }

    /// Stub
//    return Parsed._();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Parsed &&
          runtimeType == other.runtimeType &&
          origin == other.origin &&
          txt == other.txt &&
          qty == other.qty &&
          sum == other.sum &&
          done == other.done;

  @override
  int get hashCode =>
      origin.hashCode ^
      txt.hashCode ^
      qty.hashCode ^
      sum.hashCode ^
      done.hashCode;

  /// Private CTR
  const Parsed._({this.origin, this.txt, this.qty, this.sum, this.done: false});

  @override
  String toString() {
    return 'Parsed{$origin, $txt, $qty, $sum, $done}';
  }
}

/// Rules:
///
//Parsed parse(String rawStr) {
//  if (rawStr == null) {
//    return Parsed._();
//  }
//  if (rawStr.isEmpty) {
//    return Parsed._(raw: rawStr);
//  }
//
//  final lastColonIdx = rawStr.lastIndexOf(':');
//
//  if (lastColonIdx < 0) {
//    //if(lastColonIdx >= rawTxt.length-1){
//    return Parsed(rawStr, null, null);
//  }
//  //
//  final txt = rawStr.substring(0, lastColonIdx);
//  final suffix = rawStr
//      .substring(lastColonIdx + 1, rawStr.length)
//      .replaceAll(',', '.')
//      .replaceAll(' ', '');
//  final maybeQty = double.tryParse(suffix);
//  if (maybeQty != null) {
//    return Parsed(txt, maybeQty, null);
//  } else if (suffix.indexOf('=') > -1) {
//    final idx = suffix.indexOf('=');
//    final maybeQty1 = double.tryParse(suffix.substring(0, idx));
//    final maybeSum = double.tryParse(suffix.substring(idx + 1, suffix.length));
//    return maybeQty1 != null && maybeSum != null
//        ? Parsed(txt, maybeQty1, maybeSum)
//        : Parsed(rawStr, null, null);
//  } else if (suffix.indexOf('*') > -1) {
//    final idx = suffix.indexOf('*');
//    final maybeQty1 = double.tryParse(suffix.substring(0, idx));
//    final maybeMulty =
//        double.tryParse(suffix.substring(idx + 1, suffix.length));
//    return maybeQty1 != null && maybeMulty != null
//        ? Parsed(txt, maybeQty1, maybeMulty * maybeQty1)
//        : Parsed(rawStr, null, null);
//  } else {
//    return Parsed(rawStr, null, null);
//  }
//}

/// Правила
/// -----------------
/// Вначале минус - зачеркнутость (done)
/// -----------------
/// После последнего двоеточия может быть:
/// 1. 1 число
///   1.1 = число
///   1.1 просто число
/// 2. 2 числа
///   2.1 через =
///   2.2 через *
/// 3. ни одного числа, если непонятно как парсить
/// * неважно, точка или запятая в разделении целой и дробной
/// * ошибка парсинга любой части  - все считается текстом
void main() {
  final data = <String, Parsed>{
    null: Parsed._(origin: null),
    '': Parsed._(origin: ''), // empty str means no text
    '*': Parsed._(origin: '*', txt: '*'),
    '=': Parsed._(origin: '=', txt: '='),
    ':': Parsed._(origin: ':', txt: ':'),
    ' :': Parsed._(origin: ' :', txt: ' :'), // empty txt means no text
    '-': Parsed._(origin: '-', txt: '-'),
    'text: 15.5 = 1550': Parsed._(
        origin: 'text: 15.5 = 1550', txt: 'text', qty: 15.5, sum: 1550.0),
    'tx: 15.5 = 1550.0': Parsed._(
        origin: 'tx: 15.5 = 1550.0', txt: 'tx', qty: 15.5, sum: 1550.0),
    'tx: 15,5 = 1550,0': Parsed._(
        origin: 'tx: 15,5 = 1550,0', txt: 'tx', qty: 15.5, sum: 1550.0),
    'tx:15,5=1550,0':
        Parsed._(origin: 'tx:15,5=1550,0', txt: 'tx', qty: 15.5, sum: 1550.0),
    'tx 15,5=1550,0': Parsed._(origin: 'tx 15,5=1550,0', txt: 'tx 15,5=1550,0'),
    'tx 15 1550': Parsed._(origin: 'tx 15 1550', txt: 'tx 15 1550'),
    'tx:15.5=15-50': Parsed._(origin: 'tx:15.5=15-50', txt: 'tx:15.5=15-50'),
    'tx:15-5=15': Parsed._(origin: 'tx:15-5=15', txt: 'tx:15-5=15'),
    'tx:::1.=15': Parsed._(origin: 'tx:::1.=15', txt: 'tx::', qty: 1, sum: 15),
    'tx:1=2:': Parsed._(origin: 'tx:1=2:', txt: 'tx:1=2:'),
    'tx: .5 ': Parsed._(origin: 'tx: .5 ', txt: 'tx', qty: 0.5),
    'tx: ,5 ': Parsed._(origin: 'tx: ,5 ', txt: 'tx', qty: 0.5),
    'tx: ,,5': Parsed._(origin: 'tx: ,,5', txt: 'tx: ,,5'),
    'tx: ..5': Parsed._(origin: 'tx: ..5', txt: 'tx: ..5'),
    'tx: .5.': Parsed._(origin: 'tx: .5.', txt: 'tx: .5.'),
    'tx:-,5': Parsed._(origin: 'tx:-,5', txt: 'tx', qty: -0.5),
    'tx:-,5*-3,':
        Parsed._(origin: 'tx:-,5*-3,', txt: 'tx', qty: -0.5, sum: 1.5),
    'tx:1.**10':
        Parsed._(origin: 'tx:1.**10', txt: 'tx:1.**10'),
  };

  ///---------------------------
  /// Индексирую карту через лист, и прогоняю тесты циклом.
  final List<MapEntry<String, Parsed>> list = data.entries.toList();
  list.asMap().forEach((i, v) {
    final desc = 'Parser: $i. Parsing `${v.key}`';
    test(desc, () {
      print('> $desc');
      final parsed = Parsed.parse(v.key);
      expect(parsed, data[v.key]);
      print('\t\t\tresult is $parsed');
    });
  });

}
