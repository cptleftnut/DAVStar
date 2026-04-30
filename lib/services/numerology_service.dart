class NumerologyService {
  int calculateLifePathNumber(String birthDate) {
    final parts = birthDate.split('.');
    if (parts.length != 3) return 0;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    int sum = _reduce(day) + _reduce(month) + _reduce(year);
    return _reduce(sum, keepMaster: true);
  }

  int calculatePersonalYear(int lifePath, DateTime date) {
    return _reduce(lifePath + date.month);
  }

  int _reduce(int number, {bool keepMaster = false}) {
    while (number > 9) {
      if (keepMaster && (number == 11 || number == 22 || number == 33)) return number;
      number = number.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return number;
  }

  String getDescription(int number) {
    const map = {
      1: "Lederskab og nyt begyndelse",
      2: "Balance og samarbejde",
      3: "Kreativitet og glæde",
      4: "Struktur og arbejde",
      5: "Frihed og forandring",
      6: "Ansvar og kærlighed",
      7: "Introspektion og spiritualitet",
      8: "Magt og succes",
      9: "Afslutning og humanisme",
      11: "Intuition (Master Number)",
      22: "Master Builder",
      33: "Master Teacher",
    };
    return map[number] ?? "Ukendt vibration";
  }
}
