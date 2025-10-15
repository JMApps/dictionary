import '../../data/models/favorite_dictionary_model.dart';

class FavoriteDictionaryEntity {
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

  const FavoriteDictionaryEntity({
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

  factory FavoriteDictionaryEntity.fromModel(FavoriteDictionaryModel model) {
    return FavoriteDictionaryEntity(
        articleId: model.articleId,
        translation: model.translation,
        arabic: model.arabic,
        id: model.id,
        wordNumber: model.wordNumber,
        arabicWord: model.arabicWord,
        form: model.form,
        additional: model.additional,
        vocalization: model.vocalization,
        homonymNr: model.homonymNr,
        root: model.root,
        forms: model.forms,
        collectionId: model.collectionId,
        serializableIndex: model.serializableIndex,
        ankiCount: model.ankiCount
    );
  }

  String wordContent() {
    return '$arabicWord\n\n${form != null ? '$form\n\n' : ''}${vocalization != null ? '$vocalization\n\n' : ''}$root\n\n${forms != null ? '$forms\n\n' : ''}$translation'.replaceAll('\\n', '\n\n');
  }

  bool equals(FavoriteDictionaryEntity other) {
    return translation.trim() == other.translation.trim();
  }
}
