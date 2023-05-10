
import '../repository/places_repository.dart';

class DeleteAllPlaceUseCase {
  final PlacesRepository placesRepository;

  const DeleteAllPlaceUseCase({required this.placesRepository});

  call() async {
    await placesRepository.deleteAll();
  }
}