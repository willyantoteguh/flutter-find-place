import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../../shared/constant/constant.dart';
import '../../model/body/nearby_places_dto.dart';
import '../../model/response/nearby_places_response_dto.dart';

abstract class PlaceRemoteDatasource {
  // Desc
  Future<NearbyPlacesResponseDto> nearbyPlaces(
      {required NearbyPlacesDto params});
}

class PlaceRemoteDatasourceImpl extends PlaceRemoteDatasource {
  final Dio dio;

  PlaceRemoteDatasourceImpl({required this.dio});

  @override
  Future<NearbyPlacesResponseDto> nearbyPlaces(
      {required NearbyPlacesDto params}) async {
    try {
      String nearbyEndPoint =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${params.keyword}&location=${params.latitude},${params.longitude}&radius=1500&type=${params.type}&key=${Constant.apiKey}';

      var response = await dio.post(nearbyEndPoint);

      NearbyPlacesResponseDto nearbyPlacesResponseDto =
          NearbyPlacesResponseDto.fromJson(response.data);

      return nearbyPlacesResponseDto;
    } on DioError catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
