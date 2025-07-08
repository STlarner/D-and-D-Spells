import 'package:d_and_d_spells/models/spell.dart';
import 'package:d_and_d_spells/notifiers/spell_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddSpellPage extends StatefulWidget {
  final Spell? spell;
  const AddSpellPage({super.key, this.spell});

  @override
  State<AddSpellPage> createState() => _AddSpellPageState();
}

class _AddSpellPageState extends State<AddSpellPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  int? _selectedLevel;
  bool _isConcentration = false;
  bool _isBonusAction = false;
  

  @override
  void initState() {
    super.initState();
    if (widget.spell != null) {
      _titleController.text = widget.spell!.title;
      _descController.text = widget.spell!.description;
      _selectedLevel = widget.spell!.level;
      _isConcentration = widget.spell!.isConcentration;
      _isBonusAction = widget.spell!.isBonusAction;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final spellData = Spell(
        id: widget.spell?.id ?? Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        level: _selectedLevel!,
        isConcentration: _isConcentration,
        isBonusAction: _isBonusAction
      );
      if (widget.spell != null) {
        // Editing existing spell
        Provider.of<SpellNotifier>(
          context,
          listen: false,
        ).updateSpell(spellData);
      } else {
        // Adding new spell
        Provider.of<SpellNotifier>(context, listen: false).addSpell(spellData);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.spell != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Spell" : "Add New Spell")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'You need to set a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'You need to set a description'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(10, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('Lv $index${index == 0 ? ' (cantrip)' : ''}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'You need to select a level' : null,
              ),

              CheckboxListTile(
                title: const Text('Concentration'),
                value: _isConcentration,
                onChanged: (bool? value) {
                  setState(() {
                    _isConcentration = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                title: const Text('Bonus action'),
                value: _isBonusAction,
                onChanged: (bool? value) {
                  setState(() {
                    _isBonusAction = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0, // no shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // gentle rounded corners
                ),
                shadowColor: Colors.transparent,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: _submit,
              child: Text(isEditing ? "Update Spell" : "Save Spell"),
            ),
          ),
        ),
      ),
    );
  }
}
