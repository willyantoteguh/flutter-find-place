import 'package:flutter_find_places/domains/place/data/model/response/nearby_places_response_dto.dart';
import 'package:flutter_find_places/domains/place/domain/repository/places_repository.dart';

class GetAllPlaceUseCase {
  final PlacesRepository placesRepository;

  const GetAllPlaceUseCase({required this.placesRepository});

  Future<List<Results>> call() async {
    var list = await placesRepository.getAll();
    return list;
  }
}
