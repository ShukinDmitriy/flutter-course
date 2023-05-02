enum CardValue {
  two('2'), // 2
  three('3'), // 3
  four('4'), // 4
  five('5'), // 5
  six('6'), // 6
  seven('7'), // 7
  eight('8'), // 8
  nine('9'), // 9
  ten('10'), // 10
  jack('J'), // Валет
  queen('Q'), // Дама
  king('K'), // Король
  ace('A'); // Туз

  final String symbol;
  const CardValue(this.symbol);
}