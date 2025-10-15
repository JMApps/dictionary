import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/strings/app_constraints.dart';
import '../../core/strings/db_values.dart';
import '../../domain/entities/collection_entity.dart';
import '../../domain/usecases/collections_use_case.dart';

class CollectionsState extends ChangeNotifier {

  final Box _mainSettingsBox = Hive.box(AppConstraints.keyMainAppSettingsBox);
  late final CollectionsUseCase _collectionsUseCase;

  CollectionsState(this._collectionsUseCase) {
    _orderCollectionIndex = _mainSettingsBox.get(AppConstraints.keyOrderCollectionIndex, defaultValue: 0);
    _orderIndex = _mainSettingsBox.get(AppConstraints.keyOrderIndex, defaultValue: 1);
  }

  late int _orderCollectionIndex;

  int get getOrderCollectionIndex => _orderCollectionIndex;

  set setOrderCollectionIndex(int index) {
    _orderCollectionIndex = index;
    _mainSettingsBox.put(AppConstraints.keyOrderCollectionIndex, _orderCollectionIndex);
    notifyListeners();
  }

  late int _orderIndex;

  int get getOrderIndex => _orderIndex;

  set setOrderIndex(int index) {
    _orderIndex = index;
    _mainSettingsBox.put(AppConstraints.keyOrderIndex, _orderIndex);
    notifyListeners();
  }

  final List<String> _collectionOrder = [
    (DBValues.dbId),
    DBValues.dbColor,
    DBValues.dbWordsCount,
  ];

  final List<String> _order = [
    'ASC',
    'DESC',
  ];

  Future<List<CollectionEntity>> fetchAllCollections() async {
    return await _collectionsUseCase.fetchAllCollections(sortedBy: '${_collectionOrder[_orderCollectionIndex]} ${_order[_orderIndex]}');
  }

  Future<List<CollectionEntity>> fetchAllButOneCollections({required int collectionId}) async {
    return await _collectionsUseCase.fetchAllButOneCollections(collectionId: collectionId, sortedBy: '${_collectionOrder[_orderCollectionIndex]} ${_order[_orderIndex]}');
  }

  Future<CollectionEntity> getCollectionById({required int collectionId}) async {
    return await _collectionsUseCase.fetchCollectionById(collectionId: collectionId);
  }

  Future<void> addCollection({required Map<String, dynamic> mapCollection}) async {
    await _collectionsUseCase.fetchAddCollection(mapCollection: mapCollection);
    notifyListeners();
  }

  Future<void> changeCollection({required Map<String, dynamic> mapCollection}) async {
    await _collectionsUseCase.fetchChangeCollection(mapCollection: mapCollection);
    notifyListeners();
  }

  Future<int> deleteCollection({required int collectionId}) async {
    int deleteCollection = await _collectionsUseCase.fetchDeleteCollection(collectionId: collectionId);
    notifyListeners();
    return deleteCollection;
  }

  Future<int> deleteAllCollections() async {
    int deleteAllCollections = await _collectionsUseCase.fetchDeleteCollections();
    notifyListeners();
    return deleteAllCollections;
  }

  Future<int> getWordCount({required int collectionId}) async {
    return _collectionsUseCase.fetchWordCount(collectionId: collectionId);
  }
}
