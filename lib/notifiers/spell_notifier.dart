import 'dart:convert';

import 'package:d_and_d_spells/models/spell.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpellNotifier extends ChangeNotifier {
  List<Spell> _allSpells = [];
  List<Spell> get allSpells => _allSpells;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<Spell> get filteredSpells {
    return _allSpells
        .where(
          (spell) =>
              spell.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList()
      ..sort((a, b) {
        final levelCompare = b.level.compareTo(a.level);
        if (levelCompare != 0) return levelCompare;
        return a.title.compareTo(b.title);
      });
  }

  SpellNotifier() {
    _loadSpells();
  }

  Spell? getSpellById(String id) {
    try {
      return _allSpells.firstWhere((spell) => spell.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addSpell(Spell spell) async {
    _allSpells.add(spell);
    await _saveSpells();
    notifyListeners();
  }

  Future<void> removeSpell(Spell spell) async {
    _allSpells.remove(spell);
    await _saveSpells();
    notifyListeners();
  }

  Future<void> updateSpell(Spell updatedSpell) async {
    final index = _allSpells.indexWhere((s) => s.id == updatedSpell.id);
    if (index != -1) {
      _allSpells[index] = updatedSpell;
      await _saveSpells();
      notifyListeners();
    }
  }

  Future<void> _loadSpells() async {
    final prefs = await SharedPreferences.getInstance();
    final spellListJson = prefs.getStringList('spells') ?? [];
    _allSpells = spellListJson
        .map((jsonStr) => Spell.fromJson(json.decode(jsonStr)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveSpells() async {
    final prefs = await SharedPreferences.getInstance();
    final spellListJson = _allSpells
        .map((spell) => json.encode(spell.toJson()))
        .toList();
    await prefs.setStringList('spells', spellListJson);
  }
}
