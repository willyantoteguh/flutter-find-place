
import '../../data/model/response/nearby_places_response_dto.dart';
import '../repository/places_repository.dart';

class DeletePlaceUseCase {
  final PlacesRepository placesRepository;

  const DeletePlaceUseCase({required this.placesRepository});

  call(Results data) async {
    await placesRepository.delete(data: data);
  }
}