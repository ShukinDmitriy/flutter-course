import '../enums/suit.enum.dart';
import '../enums/card-value.enum.dart';

class Card {
  Suit suit;

  CardValue value;

  Card(this.suit, this.value) {}

  bool isHidden = false;

  /**
   * Отобразить карту
   */
  String show() {
    if (isHidden) {
      return '#';
    }

    String ret = '';

    switch (value) {
      case CardValue.two:
        ret += '2';
        break;
      case CardValue.three:
        ret += '3';
        break;
      case CardValue.four:
        ret += '4';
        break;
      case CardValue.five:
        ret += '5';
        break;
      case CardValue.six:
        ret += '6';
        break;
      case CardValue.seven:
        ret += '7';
        break;
      case CardValue.eight:
        ret += '8';
        break;
      case CardValue.nine:
        ret += '9';
        break;
      case CardValue.ten:
        ret += '10';
        break;
      case CardValue.jack:
        ret += 'J';
        break;
      case CardValue.queen:
        ret += 'Q';
        break;
      case CardValue.king:
        ret += 'K';
        break;
      case CardValue.ace:
        ret += 'A';
        break;
    }

    switch (suit) {
      case Suit.heart:
        ret += '︎♥';
        break;
      case Suit.diamond:
        ret += '︎♦︎';
        break;
      case Suit.club:
        ret += '♣';
        break;
      case Suit.spade:
        ret += '♠';
    }

    return ret;
  }
}