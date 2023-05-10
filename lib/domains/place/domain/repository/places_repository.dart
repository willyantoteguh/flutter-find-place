import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure_response.dart';
import '../../data/model/body/nearby_places_dto.dart';
import '../../data/model/response/nearby_places_response_dto.dart';

abstract class PlacesRepository {
  const PlacesRepository();

  Future<Either<FailureResponse, NearbyPlacesResponseDto>> getNearbyPlace(
      {required NearbyPlacesDto nearbyPlacesDto});

  Future<void> storePlaceData({required Results data});

  Future<List<Results>> getAll();

  Future<void> delete({required Results data});

  Future<void> deleteAll();
}
