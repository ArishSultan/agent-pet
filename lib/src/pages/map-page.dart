import 'dart:async';
import 'file:///D:/Workspace/Tools/Flutter/agent_pet/lib/src/ui/views/drawer_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String shopTitle;
  final String shopAddress;
  final String shopPhoneNumber;
  final LatLng shopLatLng;
  MapPage({this.shopLatLng,this.shopTitle,this.shopAddress,this.shopPhoneNumber});
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  LatLng rawLocation;
  BitmapDescriptor marker;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controller;
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(2, 2)), 'assets/icons/map-marker.png')
        .then((onValue) {
      marker = onValue;
    });
    _addMarker(widget.shopLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.shopTitle),
        ),
        body:  Stack(
          children: <Widget>[
            GoogleMap(
              compassEnabled: true,
              padding: EdgeInsets.only(top: 500),
              mapType: MapType.normal,
              initialCameraPosition:
              CameraPosition(target: widget.shopLatLng, zoom: 15),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                this.controller = controller;
              },
              onCameraMove: onCameraMove,
              markers: Set.from(allMarkers),
            ),

          ],
        ),
      ),
    );
  }

  void onCameraMove(CameraPosition position) {
    rawLocation = position.target;
  }

  void _addMarker(LatLng location) {
    allMarkers.add(Marker(
      markerId: MarkerId("shop"),
        position: location,
        infoWindow: InfoWindow(title: widget.shopTitle, snippet: widget.shopAddress,),
        icon: marker,
    ));
  }


}




