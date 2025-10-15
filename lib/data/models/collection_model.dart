import '../../core/strings/db_values.dart';

class CollectionModel {
  final int id;
  final String title;
  final int wordsCount;
  final int color;

  const CollectionModel({
    required this.id,
    required this.title,
    required this.wordsCount,
    required this.color,
  });

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map[DBValues.dbId] as int,
      title: map[DBValues.dbTitle] as String,
      wordsCount: map[DBValues.dbWordsCount] as int,
      color: map[DBValues.dbColor] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBValues.dbTitle: title,
      DBValues.dbColor: color,
    };
  }
}
