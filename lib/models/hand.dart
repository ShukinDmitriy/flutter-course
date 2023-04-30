import '../enums/card-value.enum.dart';
import 'card.dart';

class Hand {
  List<Card> cards = [];

  int get points {
    int points = 0;
    int aceCounts = 0;

    for (var card in cards) {
      switch (card.value) {
        case CardValue.two:
          points += 2;
          break;
        case CardValue.three:
          points += 3;
          break;
        case CardValue.four:
          points += 4;
          break;
        case CardValue.five:
          points += 5;
          break;
        case CardValue.six:
          points += 6;
          break;
        case CardValue.seven:
          points += 7;
          break;
        case CardValue.eight:
          points += 8;
          break;
        case CardValue.nine:
          points += 9;
          break;
        case CardValue.ace:
          aceCounts++;
          break;
        default:
          points += 10;
      }
    }

    while (aceCounts > 0) {
      if (points < 21) {
        points += 11;
      } else {
        points += 1;
      }
      aceCounts--;
    }

    return points;
  }

  void add(Card card) {
    cards.add(card);
  }

  int get length {
    return cards.length;
  }

  bool get isBlackJack {
    return length == 2 && points == 21;
  }

}