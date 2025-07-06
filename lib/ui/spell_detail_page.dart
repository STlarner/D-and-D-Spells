import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:provider/provider.dart';
import '../models/spell.dart';
import '../notifiers/spell_notifier.dart';
import 'add_spell_page.dart';

class SpellDetailPage extends StatelessWidget {
  final String spellId;

  const SpellDetailPage({super.key, required this.spellId});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpellNotifier>(
      builder: (context, spellNotifier, child) {
        final spell = spellNotifier.getSpellById(spellId);
        if (spell == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Spell not found')),
            body: const Center(
              child: Text('The spell you are looking for does not exist.'),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Spell Detail'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push<Spell>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSpellPage(spell: spell),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: spell.description));
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabelValue('Title', spell.title),
                  const SizedBox(height: 16),
                  _buildLabelValue('Description', spell.description),
                  const SizedBox(height: 16),
                  _buildLabelValue('Level', spell.level.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
