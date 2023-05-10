import 'package:flutter_find_places/domains/place/data/datasource/local/place_local_datasource.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/delete_all_place_usecase.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/delete_place_usecase.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/get_all_place_usecase.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/store_place_usecase.dart';

import '../../../injections/injections.dart';
import '../data/datasource/remote/place_remote_datasource.dart';
import '../data/repository/place_repository_impl.dart';
import '../domain/repository/places_repository.dart';
import '../domain/usecase/get_nearby_place_usecase.dart';

class PlaceDependency {
  PlaceDependency() {
    _registerDataSource();
    _registerRepository();
    _registerUseCase();
  }

  void _registerDataSource() {
    sl.registerLazySingleton<PlaceRemoteDatasource>(
      () => PlaceRemoteDatasourceImpl(
        dio: sl(),
      ),
    );
    sl.registerLazySingleton<PlaceLocalDatasource>(
        () => PlaceLocalDatasourceImpl());
  }

  void _registerRepository() {
    sl.registerLazySingleton<PlacesRepository>(
      () => PlacesRepositoryImpl(
        placeRemoteDatasource: sl(),
        placeLocalDatasource: sl(),
      ),
    );
  }

  void _registerUseCase() {
    sl.registerLazySingleton<GetNearbyPlaceUseCase>(
      () => GetNearbyPlaceUseCase(placesRepository: sl()),
    );
    sl.registerLazySingleton<StorePlaceUseCase>(
      () => StorePlaceUseCase(
        placesRepository: sl(),
      ),
    );
    sl.registerLazySingleton<GetAllPlaceUseCase>(
      () => GetAllPlaceUseCase(
        placesRepository: sl(),
      ),
    );
     sl.registerLazySingleton<DeletePlaceUseCase>(
      () => DeletePlaceUseCase(
        placesRepository: sl(),
      ),
    );
     sl.registerLazySingleton<DeleteAllPlaceUseCase>(
      () => DeleteAllPlaceUseCase(
        placesRepository: sl(),
      ),
    );
  }
}
