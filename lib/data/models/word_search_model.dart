
import '../../core/strings/db_values.dart';

class WordSearchModel {
  final int id;
  final String searchValue;

  const WordSearchModel({
    required this.id,
    required this.searchValue,
  });

  factory WordSearchModel.fromMap(Map<String, dynamic> map) {
    return WordSearchModel(
      id: map[DBValues.dbId] as int,
      searchValue: map[DBValues.dbSearchValue] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBValues.dbSearchValue: searchValue
    };
  }
}
