import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AstrologyInputScreen extends StatefulWidget {
  const AstrologyInputScreen({super.key});

  @override
  State<AstrologyInputScreen> createState() => _AstrologyInputScreenState();
}

class _AstrologyInputScreenState extends State<AstrologyInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController(text: "15.05.1992");
  final _timeController = TextEditingController(text: "14:30");
  final _latController = TextEditingController(text: "55.6761");
  final _lonController = TextEditingController(text: "12.5683");

  bool _isLoading = false;

  Future<void> _saveBirthData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Provider.of<AppProvider>(context, listen: false).loadUserBirthData(
        _dateController.text,
        _timeController.text,
        double.parse(_latController.text),
        double.parse(_lonController.text),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fødselsdata og numerologi gemt')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fejl: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Fødselsdato (DD.MM.YYYY)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Fødselsklokkeslæt (HH:MM)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _latController,
              decoration: const InputDecoration(labelText: 'Breddegrad (lat)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lonController,
              decoration: const InputDecoration(labelText: 'Længdegrad (lon)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveBirthData,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Gem fødselsdata'),
            ),
            const SizedBox(height: 24),
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.lifePathNumber == null) return const SizedBox.shrink();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Numerologi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Life Path Number: ${provider.lifePathNumber}'),
                        Text('Beskrivelse: ${provider.numService.getDescription(provider.lifePathNumber!)}'),
                        if (provider.personalYearNumber != null)
                          Text('Personligt År: ${provider.personalYearNumber}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
