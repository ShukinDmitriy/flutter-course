import '../enums/suit.dart';
import '../enums/card-value.dart';

class Card {
  Suit suit;

  CardValue value;

  Card(this.suit, this.value);

  bool isHidden = false;

  /**
   * Отобразить карту
   */
  String show() {
    if (isHidden) {
      return '#';
    }

    final ret = StringBuffer();

    ret.write(value.symbol);
    ret.write(suit.symbol);

    return ret.toString();
  }
}