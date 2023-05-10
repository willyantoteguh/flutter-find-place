import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_find_places/domains/place/data/model/body/nearby_places_dto.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/get_all_place_usecase.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/get_nearby_place_usecase.dart';
import 'package:flutter_find_places/domains/place/domain/usecase/store_place_usecase.dart';
import 'package:flutter_find_places/shared/constant/constant.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../../domains/place/data/model/response/nearby_places_response_dto.dart';
import '../../../../injections/injections.dart';

class HomeController extends GetxController {
  late GoogleMapController googleMapController;
  late LatLng initialCameraPosition;
  late Position position;
  final Mode _mode = Mode.overlay;
  Set<Marker> markers = {};
  Set<Marker> markersSearchResult = {};
  Rx<bool> isUserLocation = false.obs;
  Rx<bool> showRestaurant = false.obs;
  Rx<bool> isBookmarked = false.obs;

  RxList<Results> listStoredPlaces = <Results>[].obs;

  var kGoogleApiKey = Constant.apiKey;

  NearbyPlacesResponseDto nearbyPlacesResponse = NearbyPlacesResponseDto();

  GetNearbyPlaceUseCase getNearbyPlaceUseCase = sl();
  StorePlaceUseCase storePlaceUseCase = sl();
  GetAllPlaceUseCase getAllPlaceUseCase = sl();

  @override
  void onInit() async {
    super.onInit();
    initialCameraPosition = const LatLng(-7.602001, 111.900662);
  }

  void savePlace(Results results) async {
    storePlaceUseCase.call(results);
    isBookmarked.value = true;
    update();
    Get.snackbar('Success', 'Place has been saved successfully!');
  }

  void getAllPlace() async {
    await getAllPlaceUseCase.call().then((value) {
      listStoredPlaces.value = value;
    });
    log(listStoredPlaces.map((element) => element.name).toList().toString());
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // return Future.error('Location services are disabled');
      String title = 'Failed';
      String message = 'Location services are disabled';
      Get.snackbar(title, message,
          colorText: Colors.white, backgroundColor: Colors.black);
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  getNearMe({required NearbyPlacesDto params}) async {
    final result = await getNearbyPlaceUseCase.call(params);

    return result.fold((failure) => log(failure.errorMessage.toString()),
        (data) {
      // update();
      nearbyPlacesResponse = data;
      showRestaurant.value = true;
      update();

      Get.snackbar('Success', data.status.toString());
      log("return data: ===== ${nearbyPlacesResponse.toJson().toString()}");
    });
  }

  Future<void> searchPlace(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "id"),
        ]);

    displayPrediction(p!);
  }

  void onError(PlacesAutocompleteResponse response) {
    Get.snackbar(
      'Message',
      response.errorMessage!,
    );
  }

  Future<void> displayPrediction(Prediction p) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersSearchResult.clear();
    markersSearchResult.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: detail.result.name,
            snippet: detail.result.formattedAddress.toString())));
    markers.addAll(markersSearchResult);
    update();

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}
