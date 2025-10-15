import '../../core/strings/db_values.dart';

class DictionaryModel {
  final String articleId;
  final String translation;
  final String arabic;
  final int id;
  final int wordNumber;
  final String arabicWord;
  final String? form;
  final String? additional;
  final String? vocalization;
  final int? homonymNr;
  final String root;
  final String? forms;

  const DictionaryModel({
    required this.articleId,
    required this.translation,
    required this.arabic,
    required this.id,
    required this.wordNumber,
    required this.arabicWord,
    required this.form,
    required this.additional,
    required this.vocalization,
    required this.homonymNr,
    required this.root,
    required this.forms,
  });

  factory DictionaryModel.fromMap(Map<String, dynamic> map) {
    return DictionaryModel(
      articleId: map[DBValues.dbArticleId] as String,
      translation: map[DBValues.dbTranslation] as String,
      arabic: map[DBValues.dbArabic] as String,
      id: map[DBValues.dbId] as int,
      wordNumber: map[DBValues.dbWordNumber] as int,
      arabicWord: map[DBValues.dbArabicWord] as String,
      form: map[DBValues.dbForm] as String?,
      additional: map[DBValues.dbAdditional] as String?,
      vocalization: map[DBValues.dbVocalization] as String?,
      homonymNr: map[DBValues.dbHomonymNr] as int?,
      root: map[DBValues.dbRoot] as String,
      forms: map[DBValues.dbForms] as String?,
    );
  }
}
