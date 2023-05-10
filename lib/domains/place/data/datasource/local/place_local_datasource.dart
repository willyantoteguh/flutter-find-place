import 'dart:developer';

import 'package:flutter_find_places/domains/place/data/model/response/nearby_places_response_dto.dart';
import 'package:sembast/sembast.dart';

import '../../../../../core/local/sembast.dart';

abstract class PlaceLocalDatasource {
  const PlaceLocalDatasource();

  Future storePlaceData({required Results data});

  // Future insertFromList({required list});

  Future<List<Results>> getAll();

  Future delete({required Results data});

  Future deleteAll();
}

class PlaceLocalDatasourceImpl extends PlaceLocalDatasource {
  static const String STORE_NAME = "place_nearme";
  final _store = intMapStoreFactory.store(STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  @override
  Future storePlaceData({required Results data}) async {
    await _store.add(await _db, data.toJson());
    log(data.toJson().toString());
  }

  @override
  Future delete({required Results data}) async {
    var finder = Finder(filter: Filter.equals('place_id', data.placeId));
    return await _store.delete(await _db, finder: finder);
  }

  @override
  Future deleteAll() async {
    await _store.delete(await _db);
  }

  @override
  Future<List<Results>> getAll() async {
    final finder = Finder(sortOrders: [SortOrder('place_id')]);

    final list = await _store.find(await _db, finder: finder);
    return list.map((e) {
      final item = Results.fromJson(e.value);
      return item;
    }).toList();
  }
}
