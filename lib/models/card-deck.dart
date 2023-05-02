import '../enums/card-value.dart';
import '../enums/suit.dart';
import 'card.dart';

class CardDeck {
  List<Card> cards = [];

  CardDeck() {
    for (var suit in Suit.values) {
      for (var value in CardValue.values) {
        cards.add(Card(suit, value));
      }
    }
  }

  void shuffle() {
    cards.shuffle();
  }

  Card? getCard() {
    if (cards.isEmpty) {
      return null;
    }

    Card card = cards.last;
    cards.removeLast();

    return card;
  }
}