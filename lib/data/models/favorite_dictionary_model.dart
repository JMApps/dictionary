import '../../core/strings/db_values.dart';

class FavoriteDictionaryModel {
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
  final int collectionId;
  final int serializableIndex;
  final int ankiCount;

  const FavoriteDictionaryModel({
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
    required this.collectionId,
    required this.serializableIndex,
    required this.ankiCount,
  });

  factory FavoriteDictionaryModel.fromMap(Map<String, dynamic> map) {
    return FavoriteDictionaryModel(
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
      collectionId: map[DBValues.dbCollectionId] as int,
      serializableIndex: map[DBValues.dbSerializableIndex] as int,
      ankiCount: map[DBValues.dbAnkiCount] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBValues.dbArticleId : articleId,
      DBValues.dbTranslation : translation,
      DBValues.dbArabic : arabic,
      DBValues.dbWordNumber : wordNumber,
      DBValues.dbArabicWord : arabicWord,
      DBValues.dbForm : form,
      DBValues.dbAdditional: additional,
      DBValues.dbVocalization : vocalization,
      DBValues.dbHomonymNr: homonymNr,
      DBValues.dbRoot : root,
      DBValues.dbForms : forms,
      DBValues.dbCollectionId : collectionId,
      DBValues.dbSerializableIndex : serializableIndex,
      DBValues.dbAnkiCount : ankiCount,
    };
  }
}
