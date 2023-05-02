import '../enums/decide.dart';
import 'person.dart';
import 'dart:io';

class User extends Person {
  @override
  Decide decide() {
    stdout.writeln('Примите решение: T,t - взять еще, P,p - пасс.');
    String decide = (stdin.readLineSync() ?? '').trim();

    switch (decide) {
      case 'T':
      case 't':
        return Decide.take;
      case 'P':
      case 'p':
        return Decide.pass;
    }

    stdout.writeln('Неизвестная команда');
    return this.decide();
  }
}
