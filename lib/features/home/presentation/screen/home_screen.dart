import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domains/place/data/model/body/nearby_places_dto.dart';
import '../../../../shared/constant/constant.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            key: homeScaffoldKey,
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      // bearing: 192.8334901395799,
                      target: controller.initialCameraPosition,
                      // tilt: 59.440717697143555,
                      zoom: 12),
                  markers: controller.markers,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController newGoogleMapController) {
                    controller.googleMapController = newGoogleMapController;
                  },
                  onLongPress: (LatLng newValue) {
                    controller.markers.clear();

                    controller.markers.add(Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: LatLng(newValue.latitude, newValue.longitude),
                        draggable: true,
                        onDragEnd: ((newLocation) {
                          setState(() {
                            controller.markers.clear();
                            controller.markers.add(
                              Marker(
                                markerId: const MarkerId('onDragNewLocation'),
                                position: LatLng(newLocation.latitude,
                                    newLocation.longitude),
                              ),
                            );
                            log("onTap map: ${controller.markers.last.position.latitude.toString()}");
                            log(controller.markers.last.position.longitude
                                .toString());
                          });
                        })));
                  },
                ),
                Visibility(
                  visible: controller.showRestaurant.value,
                  child: Positioned(
                    left: 15,
                    bottom: 30,
                    child: SizedBox(
                      height: Get.height / 6,
                      width: Get.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller
                                  .nearbyPlacesResponse.results?.length,
                              itemBuilder: (context, index) {
                                var item = controller
                                    .nearbyPlacesResponse.results![index];

                                return SizedBox(
                                  height: 80,
                                  width: 200,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      controller
                                                          .savePlace(item);
                                                    },
                                                    icon: const Icon(Icons
                                                        .bookmark_outline_rounded)),
                                              ],
                                            ),
                                            Text(item.name.toString()),
                                            Text(
                                                "Location: ${item.geometry!.location!.lat} , ${item.geometry!.location!.lng}"),
                                            Text(item.openingHours != null
                                                ? "Open"
                                                : "Closed"),
                                            const Spacer(),
                                          ],
                                        ),
                                      )),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          onPressed: () {
                            homeScaffoldKey.currentState!.openDrawer();
                          },
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.blueGrey,
                            size: 35,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => controller.searchPlace(context),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            // padding: const EdgeInsets.only(top: 40),
                            // constraints: BoxConstraints(
                            //   minHeight: 50,
                            //   minWidth:
                            // ),
                            height: 45,
                            width: Get.width - 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Icon(CupertinoIcons.search),
                                ),
                                Text('Search ...'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const ListTile(),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on_rounded,
                    ),
                    title: const Text('My Location'),
                    onTap: () async {
                      Navigator.pop(context);
                      await userCurrentPosition(controller);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.food_bank_rounded,
                    ),
                    title: const Text('Restaurant Near Me'),
                    onTap: () async {
                      Navigator.pop(context);

                      if (controller.isUserLocation.value) {
                        var params = NearbyPlacesDto(
                          keyword: 'restoran',
                          latitude: controller.markers.last.position.latitude
                              .toString(),
                          longitude: controller.markers.last.position.longitude
                              .toString(),
                          radius: "15000",
                          type: 'restaurant',
                          apiKey: Constant.apiKey,
                        );
                        await controller.getNearMe(params: params);
                      } else {
                        Get.snackbar('User Location Unkown',
                            'Get Your Current Location By Tap , My Location Option First',
                            duration: const Duration(seconds: 3));
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.local_hospital_rounded,
                    ),
                    title: const Text('Hospital Near Me'),
                    onTap: () async {
                      Navigator.pop(context);

                      if (controller.isUserLocation.value) {
                        var params = NearbyPlacesDto(
                          keyword: 'Rumah Sakit Umum',
                          latitude: controller.markers.first.position.latitude
                              .toString(),
                          longitude: controller.markers.first.position.longitude
                              .toString(),
                          radius: "15000",
                          type: 'hospital',
                          apiKey: Constant.apiKey,
                        );
                        await controller.getNearMe(params: params);
                      } else {
                        Get.snackbar('User Location Unkown',
                            'Get Your Current Location By Tap , My Location Option First',
                            duration: const Duration(seconds: 3));
                      }
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.bookmark),
                      title: const Text('Bookmarked Place'),
                      onTap: () {
                        controller.getAllPlace();

                        Future.delayed(const Duration(seconds: 2), ()=> showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                title: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text("Show List Places"),
                                ),
                                content: SingleChildScrollView(
                                  child: Obx(
                                    () => ListBody(
                                        children: controller.listStoredPlaces
                                            .map<Widget>((element) {
                                      return ListTile(
                                        leading: Image.network(
                                            element.icon.toString()),
                                        title: Text(element.name.toString()),
                                        subtitle:
                                            Text(element.rating.toString()),
                                      );
                                    }).toList()),
                                  ),
                                ),
                              );
                            });
                          },
                        ));
                      })
                ],
              ),
            ),
          );
        });
  }

  Future<void> userCurrentPosition(HomeController controller) async {
    controller.position = await controller.getCurrentPosition();

    controller.googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                controller.position.latitude, controller.position.longitude),
            zoom: 18)));

    controller.markers.clear();

    controller.markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position:
            LatLng(controller.position.latitude, controller.position.longitude),
        draggable: true,
        onDragEnd: ((newLocation) {
          setState(() {
            controller.markers.clear();
            controller.markers.add(
              Marker(
                markerId: const MarkerId('onDragNewLocation'),
                position: LatLng(newLocation.latitude, newLocation.longitude),
              ),
            );
            log(controller.markers.last.position.latitude.toString());
            log(controller.markers.last.position.longitude.toString());
          });
        })));

    controller.isUserLocation.value = true;
    controller.update();
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String location =
        'https://www.google.com/maps/search/hospital/@$latitude,$longitude/data=!3m1!4b1';
    String googleUrl = 'https://www.google.com/maps/search/hospitals ';
    if (await canLaunch(location)) {
      await launch(location);
    } else {
      throw 'Could not open the map.';
    }
  }
}
