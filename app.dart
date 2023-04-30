import 'lib/index.dart' as blackjack;

int main() {
  try {
    blackjack.BlackjackController controller =  blackjack.BlackjackController();

    while (controller.game()) {

    }

    return 0;
  } catch (e) {
    return 1;
  }
}
