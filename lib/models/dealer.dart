import '../enums/decide.enum.dart';
import 'card.dart';
import 'person.dart';

class Dealer extends Person {
  Card? firstCard;

  @override
  Decide decide() {
    return hand.points < 17 ? Decide.take : Decide.pass;
  }

  @override
  void takeCard(Card? card) {
    if (firstCard == null) {
      firstCard = card;
      card?.isHidden = true;
    }
    super.takeCard(card);
  }
}