import 'package:dartz/dartz.dart';

import '../../../../shared/error/failure_response.dart';
import '../../../../shared/use_case/use_case.dart';
import '../../data/model/body/nearby_places_dto.dart';
import '../../data/model/response/nearby_places_response_dto.dart';
import '../repository/places_repository.dart';

class GetNearbyPlaceUseCase
    extends UseCase<NearbyPlacesResponseDto, NearbyPlacesDto> {
  final PlacesRepository placesRepository;

  const GetNearbyPlaceUseCase({required this.placesRepository});

  @override
  Future<Either<FailureResponse, NearbyPlacesResponseDto>> call(
          NearbyPlacesDto params) async =>
      await placesRepository.getNearbyPlace(nearbyPlacesDto: params);
}
