import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/tarot_deck.dart';
import '../models/tarot_card.dart';
import '../providers/app_provider.dart';
import '../services/tarot_interpretation_service.dart';

class TarotReadingScreen extends StatefulWidget {
  const TarotReadingScreen({super.key});

  @override
  State<TarotReadingScreen> createState() => _TarotReadingScreenState();
}

class _TarotReadingScreenState extends State<TarotReadingScreen> {
  String _selectedSpread = 'Tre-korts spread';
  final List<String> _spreads = [
    'Tre-korts spread',
    'Kærlighedsspread',
    'Karriere & Arbejde',
    'Sundhed & Balance',
    'Beslutningsspread',
  ];

  List<Map<String, dynamic>> _drawnCards = [];
  String? _readingResult;
  bool _isLoading = false;

  final TarotInterpretationService _interpretationService = TarotInterpretationService();

  List<Map<String, dynamic>> _drawCards(int count) {
    final deckCopy = List<TarotCard>.from(tarotDeck);
    deckCopy.shuffle();

    return deckCopy.take(count).map((card) {
      final isReversed = DateTime.now().microsecondsSinceEpoch % 2 == 0;
      return {
        "card": card,
        "isReversed": isReversed,
        "display": "${card.name} (${isReversed ? 'omvendt' : 'oprejst'})",
        "imagePath": card.imagePath,
      };
    }).toList();
  }

  Future<void> _performReading() async {
    final provider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
      _readingResult = null;
    });

    try {
      _drawnCards = _drawCards(3);

      final result = _interpretationService.generateReading(
        drawnCards: _drawnCards,
        spreadType: _selectedSpread,
        birthDate: provider.birthDateStr,
        lifePathNumber: provider.lifePathNumber,
        personalYear: provider.personalYearNumber,
        conversationHistory: provider.getConversationHistory(),
      );

      setState(() => _readingResult = result);
      provider.addReading(_selectedSpread, result);
    } catch (e) {
      setState(() => _readingResult = 'Fejl: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSpread,
            decoration: const InputDecoration(labelText: 'Vælg spread-type'),
            items: _spreads.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => _selectedSpread = val!),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _performReading,
            icon: const Icon(Icons.shuffle),
            label: const Text('Træk kort og få fortolkning'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
          const SizedBox(height: 20),

          if (_isLoading) const CircularProgressIndicator(),

          if (_drawnCards.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Trukne kort:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _drawnCards.length,
                itemBuilder: (context, index) {
                  final card = _drawnCards[index];
                  return Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          card['imagePath'] as String,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Text(
                                (card['card'] as TarotCard).name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        card['display'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          if (_readingResult != null)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_readingResult!, style: const TextStyle(fontSize: 16, height: 1.6)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
