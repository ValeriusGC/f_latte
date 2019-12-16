import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class Straight {
  final String name;
  final int age;

//<editor-fold desc="Data Methods" defaultstate="collapsed">


  const Straight({
    @required this.name,
    @required this.age,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Straight &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              age == other.age
          );


  @override
  int get hashCode =>
      name.hashCode ^
      age.hashCode;


  @override
  String toString() {
    return 'Straight{' +
        ' name: $name,' +
        ' age: $age,' +
        '}';
  }


  Straight copyWith({
    String name,
    int age,
  }) {
    return new Straight(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
    };
  }

  factory Straight.fromMap(Map<String, dynamic> map) {
    return new Straight(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }


//</editor-fold>
}

class Gay {
  final String name;
  final int age;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Gay({
    @required this.name,
    @required this.age,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Gay &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              age == other.age
          );


  @override
  int get hashCode =>
      name.hashCode ^
      age.hashCode;


  @override
  String toString() {
    return 'Gay{' +
        ' name: $name,' +
        ' age: $age,' +
        '}';
  }


  Gay copyWith({
    String name,
    int age,
  }) {
    return new Gay(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'age': this.age,
    };
  }

  factory Gay.fromMap(Map<String, dynamic> map) {
    return new Gay(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }


//</editor-fold>
}

void main() {
  test('Когда все пошло не по плану', () async {

    // в точке А.
    final manBefore = Straight(name: 'Serg', age: 25);
    final map = manBefore.toMap();
    print('man before is: ${manBefore.runtimeType} as $map');

    // в точке Б.
    final manAfter = Gay.fromMap(map);
    print('man after is: ${manAfter.runtimeType} as $map');

  });
}
