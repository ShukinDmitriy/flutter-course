import 'dart:io';

import '../models/dealer.dart';
import '../models/person.dart';
import '../models/user.dart';

class ConsoleDisplayService {
  bool _confirm(String message) {
    stdout.writeln('${message} Y,y - да, N,n - нет');
    String confirm = (stdin.readLineSync() ?? '').trim();

    if (['Y', 'y'].contains(confirm)) {
      return true;
    }

    if (['N', 'n'].contains(confirm)) {
      return false;
    }

    stdout.writeln('Неизвестная команда');
    return this._confirm(message);
  }

  /**
   * Предложить пользователю забрать выигрыш
   */
  bool pickUpWin() {
    return _confirm('Хотите забрать выигрыш 1:1?');
  }

  /**
   * Пользователь проиграл
   */
  bool lose() {
    return _confirm('Вы проиграли. Хотите сыграть еще раз?');
  }

  /**
   * Пользователь выиграл
   */
  bool win() {
    return _confirm('Вы выиграли. Хотите сыграть еще раз?');
  }

  /**
   * Ничья
   */
  bool draw() {
    return _confirm('Ровно. Хотите сыграть еще раз?');
  }

  void _shownCurrentByPerson(Person person, String role) {
    String message = person.hand.length == 0 ? 'У ${role} нет карт' : 'У ${role} на руках: ';
    List<String> cards = [];
    bool hasHidden = false;
    for (var card in person.hand.cards) {
      cards.add(card.show());
      hasHidden = hasHidden || card.isHidden;
    }
    message += cards.join(',') + '.';
    if (!hasHidden) {
      message += ' Количество очков: ' + person.hand.points.toString();
    }
    stdout.writeln(message);
  }

  /**
   * Отобразить текущие карты
   */
  void current(User user, Dealer dealer) {
    _shownCurrentByPerson(user, 'игрока');
    _shownCurrentByPerson(dealer, 'дилера');
  }
}