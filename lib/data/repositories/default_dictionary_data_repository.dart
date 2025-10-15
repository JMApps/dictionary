import 'package:sqflite/sqflite.dart';

import '../../core/strings/db_values.dart';
import '../../domain/entities/dictionary_entity.dart';
import '../../domain/repositories/default_dictionary_repository.dart';
import '../models/dictionary_model.dart';
import '../services/default_dictionary_service.dart';

class DefaultDictionaryDataRepository implements DefaultDictionaryRepository {
  final DefaultDictionaryService _dictionaryService;

  const DefaultDictionaryDataRepository(this._dictionaryService);

  @override
  Future<List<DictionaryEntity>> getAllWords() async {
    final Database database = await _dictionaryService.db;
    final List<Map<String, Object?>> resources = await database.rawQuery(
      "SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms "
          "FROM ${DBValues.dbTableOfSearch} s INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number "
    );
    final List<DictionaryEntity> allWords = resources.isNotEmpty ? resources.map((c) => DictionaryEntity.fromModel(DictionaryModel.fromMap(c))).toList() : [];
    return allWords;
  }

  @override
  Future<List<DictionaryEntity>> getWordsByRoot({required String wordRoot, required int excludedId}) async {
    final Database database = await _dictionaryService.db;
    final List<Map<String, Object?>> resources = await database.rawQuery(
      "SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms "
          "FROM ${DBValues.dbTableOfSearch} s INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number WHERE d.root = ? AND d.word_number != ?",
      [wordRoot, excludedId],
    );
    final List<DictionaryEntity> wordsByRoot = resources.isNotEmpty ? resources.map((c) => DictionaryEntity.fromModel(DictionaryModel.fromMap(c))).toList() : [];
    return wordsByRoot;
  }

  @override
  Future<DictionaryEntity> getWordById({required int wordNumber}) async {
    final Database database = await _dictionaryService.db;
    final List<Map<String, Object?>> resources = await database.rawQuery(
      "SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms "
          "FROM ${DBValues.dbTableOfSearch} s INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number WHERE d.word_number = ?", [wordNumber],
    );
    final DictionaryEntity? wordById = resources.isNotEmpty ? DictionaryEntity.fromModel(DictionaryModel.fromMap(resources.first)) : null;
    return wordById!;
  }

  @override
  Future<List<DictionaryEntity>> searchWords({required String searchQuery, required bool exactMatch}) async {
    final Database database = await _dictionaryService.db;
    final bool isArabic = isArabicInput(searchQuery);
    final String cleanedQuery = removeDiacriticsAndNormalize(searchQuery);
    final List<Map<String, Object?>> resources = await database.rawQuery("SELECT s.article_id, s.translation, s.arabic, s.full_arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms FROM ${DBValues.dbTableOfSearch} s JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number WHERE s.rowid IN (SELECT rowid FROM ${DBValues.dbTableOfSearch} WHERE ${isArabic ? '' : 'translation MATCH ? OR '} arabic MATCH ? OR full_arabic MATCH ? ORDER BY article_id ASC)",
        exactMatch ? isArabic ? ['"$cleanedQuery"', '"$searchQuery"'] : ['"$searchQuery"', '"$cleanedQuery"', '"$searchQuery"'] : isArabic? ['$cleanedQuery*', '$searchQuery*'] : ['$searchQuery*', '$cleanedQuery*', '$searchQuery*']
    );
    final List<DictionaryEntity> searchWords = resources.isNotEmpty ? resources.map((c) => DictionaryEntity.fromModel(DictionaryModel.fromMap(c))).toList() : [];
    return searchWords;
  }

  @override
  Future<List<DictionaryEntity>> getWordsByQuiz({required int wordNumber}) async {
    final Database database = await _dictionaryService.db;

    final List<Map<String, Object?>> wordResult = await database.rawQuery('''
    SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms
    FROM ${DBValues.dbTableOfSearch} s
    INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number WHERE d.word_number = ?''', [wordNumber]);

    final List<DictionaryEntity> resultList = [];

    if (wordResult.isNotEmpty) {
      final DictionaryModel word = DictionaryModel.fromMap(wordResult.first);
      resultList.add(DictionaryEntity.fromModel(word));

      final List<Map<String, Object?>> optionsResult = await database.rawQuery('''
      SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms
      FROM ${DBValues.dbTableOfSearch} s
      INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number
      WHERE d.word_number > ?
      ORDER BY d.word_number ASC
      LIMIT 3
    ''', [wordNumber]);

      if (optionsResult.length < 3) {
        final List<Map<String, Object?>> precedingResult = await database.rawQuery('''
        SELECT s.article_id, s.translation, s.arabic, d.id, d.word_number, d.arabic_word, d.form, d.additional, d.vocalization, d.homonym_nr, d.root, d.forms
        FROM ${DBValues.dbTableOfSearch} s
        INNER JOIN ${DBValues.dbTableOfDictionary} d ON s.article_id = d.word_number
        WHERE d.word_number < ?
        ORDER BY d.word_number DESC
        LIMIT 3
      ''', [wordNumber]);

        for (var precedingOption in precedingResult.reversed) {
          final DictionaryModel optionWord = DictionaryModel.fromMap(precedingOption);
          if (!resultList.contains(DictionaryEntity.fromModel(optionWord))) {
            resultList.insert(0, DictionaryEntity.fromModel(optionWord));
          }
        }
      }

      for (final option in optionsResult) {
        final DictionaryModel optionWord = DictionaryModel.fromMap(option);
        if (!resultList.contains(DictionaryEntity.fromModel(optionWord))) {
          resultList.add(DictionaryEntity.fromModel(optionWord));
        }
      }
    }

    return resultList;
  }

  String removeDiacriticsAndNormalize(String input) {
    final diacriticsPattern = RegExp(r'[ًٌٍَُِّْٰۛۚ]');
    String withoutDiacritics = input.replaceAll(diacriticsPattern, '');
    String normalizedAlif = withoutDiacritics.replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    String normalizedAlifYa = normalizedAlif.replaceAll(RegExp(r'[ئ]'), 'ى');
    String normalizedWow = normalizedAlifYa.replaceAll(RegExp(r'[ؤ]'), 'و');
    String normalizedYa = normalizedWow.replaceAll(RegExp(r'[ي]'), 'ى');
    String withoutExtraSpaces = normalizedYa.replaceAll(RegExp(r'\s+'), ' ').trim();

    return withoutExtraSpaces;
  }

  bool isArabicInput(String input) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(input);
  }
}
