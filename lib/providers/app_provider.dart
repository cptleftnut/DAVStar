import 'package:flutter/material.dart';
import '../services/astrology_service.dart';
import '../services/numerology_service.dart';

class AppProvider extends ChangeNotifier {
  final AstrologyService astroService = AstrologyService();
  final NumerologyService numService = NumerologyService();

  Map<String, dynamic>? natalData;
  Map<String, dynamic>? transitData;
  int? lifePathNumber;
  int? personalYearNumber;
  String? birthDateStr;

  final List<Map<String, String>> _history = [];

  void addReading(String spreadType, String reading) {
    _history.add({
      "date": DateTime.now().toIso8601String(),
      "spread": spreadType,
      "summary": reading.length > 250 ? "${reading.substring(0, 250)}..." : reading,
    });
    notifyListeners();
  }

  List<Map<String, String>> get history => _history;

  String getConversationHistory() {
    if (_history.isEmpty) return "Ingen tidligere læsninger.";
    return _history.reversed.take(3).map((e) =>
      "• ${e['date']?.substring(0, 10)} – ${e['spread']}: ${e['summary']}"
    ).join("\n");
  }

  Future<void> loadUserBirthData(String birthDate, String birthTime, double lat, double lon) async {
    birthDateStr = birthDate;
    lifePathNumber = numService.calculateLifePathNumber(birthDate);
    personalYearNumber = numService.calculatePersonalYear(lifePathNumber ?? 0, DateTime.now());

    try {
      natalData = await astroService.fetchPlanets(
        date: birthDate,
        time: birthTime,
        latitude: lat,
        longitude: lon,
      );
    } catch (e) {
      natalData = null;
    }
    notifyListeners();
  }

  Future<void> loadTransitData() async {
    try {
      transitData = await astroService.fetchPlanets(
        date: "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
        time: "12:00",
        latitude: 55.6761,
        longitude: 12.5683,
      );
    } catch (e) {
      transitData = null;
    }
    notifyListeners();
  }
}
