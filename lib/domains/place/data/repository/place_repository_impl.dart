import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_find_places/domains/place/data/datasource/local/place_local_datasource.dart';

import '../../../../shared/error/failure_response.dart';
import '../../domain/repository/places_repository.dart';
import '../datasource/remote/place_remote_datasource.dart';
import '../model/body/nearby_places_dto.dart';
import '../model/response/nearby_places_response_dto.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlaceRemoteDatasource placeRemoteDatasource;
  final PlaceLocalDatasource placeLocalDatasource;

  PlacesRepositoryImpl(
      {required this.placeRemoteDatasource,
      required this.placeLocalDatasource});

  @override
  Future<Either<FailureResponse, NearbyPlacesResponseDto>> getNearbyPlace(
      {required NearbyPlacesDto nearbyPlacesDto}) async {
    try {
      final response =
          await placeRemoteDatasource.nearbyPlaces(params: nearbyPlacesDto);
      return Right(response);
    } on DioError catch (error) {
      return Left(
        FailureResponse(
          errorMessage: error.response?.data["messsage"]?.toString() ??
              error.response.toString(),
        ),
      );
    }
  }

  @override
  Future<void> delete({required Results data}) async {
    placeLocalDatasource.delete(data: data);
  }

  @override
  Future<void> deleteAll() async {
    placeLocalDatasource.deleteAll();
  }

  @override
  Future<List<Results>> getAll() async {
    var allPlaces = await placeLocalDatasource.getAll();
    return allPlaces;
  }

  @override
  Future<void> storePlaceData({required Results data}) async {
    placeLocalDatasource.storePlaceData(data: data);
  }
}
