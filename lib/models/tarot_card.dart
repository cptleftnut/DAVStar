class TarotCard {
  final String id;
  final String name;
  final String englishName;
  final String suit;

  TarotCard({
    required this.id,
    required this.name,
    required this.englishName,
    required this.suit,
  });

  String get imagePath {
    String fileName = name.toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('æ', 'ae')
        .replaceAll('ø', 'oe')
        .replaceAll('å', 'aa');
    return 'assets/tarot_cards/${id}_$fileName.jpg';
  }
}
