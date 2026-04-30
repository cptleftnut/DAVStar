import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class DailyHoroscopeScreen extends StatefulWidget {
  const DailyHoroscopeScreen({super.key});

  @override
  State<DailyHoroscopeScreen> createState() => _DailyHoroscopeScreenState();
}

class _DailyHoroscopeScreenState extends State<DailyHoroscopeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).loadTransitData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dagens Transitter',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  provider.transitData?.toString() ?? 'Indlæser transitter...\n\n(Tilføj din FreeAstroAPI-nøgle via Indstillinger for at se live data)',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 24),
                if (provider.lifePathNumber != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Din numerologi i dag',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Life Path: ${provider.lifePathNumber}\n'
                            '${provider.numService.getDescription(provider.lifePathNumber!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (provider.personalYearNumber != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Personligt År: ${provider.personalYearNumber}\n'
                              '${provider.numService.getDescription(provider.personalYearNumber!)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
