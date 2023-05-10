
import '../../data/model/response/nearby_places_response_dto.dart';
import '../repository/places_repository.dart';

class StorePlaceUseCase {
  final PlacesRepository placesRepository;

  const StorePlaceUseCase({required this.placesRepository});

  call(Results data) async {
    await placesRepository.storePlaceData(data: data);
  }
}