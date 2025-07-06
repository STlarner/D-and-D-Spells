import 'package:d_and_d_spells/models/spell.dart';
import 'package:d_and_d_spells/notifiers/spell_notifier.dart';
import 'package:d_and_d_spells/ui/add_spell_page.dart';
import 'package:d_and_d_spells/ui/spell_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("D&D Spells"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push<Spell>(
                context,
                MaterialPageRoute(builder: (context) => const AddSpellPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<SpellNotifier>(
        builder: (context, spellNotifier, _) {
          final filteredSpells = spellNotifier.filteredSpells;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Search Spells",
                    border: OutlineInputBorder(),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  onChanged: spellNotifier.updateSearchQuery,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredSpells.length,
                  itemBuilder: (context, index) {
                    final spell = filteredSpells[index];
                    return Dismissible(
                      key: Key(spell.title),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        await spellNotifier.removeSpell(spell);
                      },
                      child: ListTile(
                        title: Text(spell.title),
                        leading: Text(
                          "Lv ${spell.level}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpellDetailPage(spellId: spell.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.0, end: 24.0),
                    child: const Divider(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
