import '../../data/models/collection_model.dart';

class CollectionEntity {
  final int id;
  final String title;
  final int wordsCount;
  final int color;

  const CollectionEntity({
    required this.id,
    required this.title,
    required this.wordsCount,
    required this.color,
  });
  
  factory CollectionEntity.fromModel(CollectionModel model) {
    return CollectionEntity(
      id: model.id,
      title: model.title,
      wordsCount: model.wordsCount,
      color: model.color,
    );
  }

  bool equals(CollectionEntity other) {
    return title.trim() == other.title.trim() && color == other.color;
  }
}
