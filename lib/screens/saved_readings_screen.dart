import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SavedReadingsScreen extends StatelessWidget {
  const SavedReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.history.isEmpty) {
          return const Center(child: Text('Ingen gemte læsninger endnu'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.history.length,
          itemBuilder: (context, index) {
            final item = provider.history[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(item['spread'] ?? ''),
                subtitle: Text(item['summary'] ?? ''),
                trailing: Text(item['date']?.substring(0, 10) ?? ''),
              ),
            );
          },
        );
      },
    );
  }
}
