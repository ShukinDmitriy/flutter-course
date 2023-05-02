import 'lib/index.dart' as blackjack;

int main() {
  try {
    blackjack.Blackjack controller =  blackjack.Blackjack();

    while (controller.game()) {

    }

    return 0;
  } catch (e) {
    return 1;
  }
}
