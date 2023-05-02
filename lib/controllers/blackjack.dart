import '../enums/decide.dart';
import '../models/card-deck.dart';
import '../enums/card-value.dart';
import '../models/dealer.dart';
import '../models/person.dart';
import '../models/user.dart';
import '../services/console-display.dart';

class Blackjack {

  ConsoleDisplayService displayService = ConsoleDisplayService();

  void _takeCards(Person person, CardDeck cardDeck, User user, Dealer dealer) {
    while (person.hand.points < 21 && person.decide() == Decide.take) {
      person.takeCard(cardDeck.getCard());
      displayService.current(user, dealer);
    }
  }

  bool game() {
    CardDeck cardDeck = CardDeck();
    cardDeck.shuffle();


    User user = User();
    Dealer dealer = Dealer();

    List<Person> users = [user, dealer];

    // Расдача карт
    for (var user in users) {
      user.takeCard(cardDeck.getCard());
      user.takeCard(cardDeck.getCard());
    }

    displayService.current(user, dealer);

    // У игрока блекджек
    if (user.hand.isBlackJack && dealer.firstCard?.value == CardValue.ace) {
      if (displayService.pickUpWin()) {
        return displayService.draw();
      }

      _takeCards(dealer, cardDeck, user, dealer);
    }

    // Добор карт
    _takeCards(user, cardDeck, user, dealer);
    dealer.firstCard?.isHidden = false;
    _takeCards(dealer, cardDeck, user, dealer);

    // Определение победителя
    if (user.hand.points > 21 || (dealer.hand.points <= 21 && dealer.hand.points > user.hand.points)) {
      return displayService.lose();
    }

    if (user.hand.points == dealer.hand.points) {
      return displayService.draw();
    }

    return displayService.win();
  }
}