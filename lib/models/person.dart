import '../enums/decide.enum.dart';
import 'card.dart';
import 'hand.dart';

abstract class Person {
  Hand hand = Hand();

  Decide decide();

  void takeCard(Card? card) {
    if (card != null) {
      hand.add(card);
    }
  }

}
