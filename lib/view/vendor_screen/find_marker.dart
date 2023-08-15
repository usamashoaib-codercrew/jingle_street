import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/fields/search_field.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLatLng;
  Position? currentPostion;
  Set<Marker> _markers = {};
  Map<String, dynamic>? gotIt;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  _getCurrentLocation() async {
    currentPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
      ));
      _selectedLatLng = latLng;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _onMapCreated;
    super.dispose();
  }

//this is google Map where we put marker to get pin location
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPostion == null
          ? Center(child: CircularProgressIndicator())
          : Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          onTap: _onMapTap,
          markers: _markers,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                currentPostion == null
                    ? 31.5204
                    : currentPostion!.latitude,
                currentPostion == null
                    ? 74.3587
                    : currentPostion!.longitude),
            zoom: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
          child: SearchField(
            onSubmitted: (value) async {
              await _searchLocation(searchText: value);
              //here this Code Search the location of the Shop when we provide Address in SearchField
              GoogleMapController mapController =
              await _controller.future;
              await mapController
                  .animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(gotIt!['lat'], gotIt!['lng']),
                    zoom: 15.0),
              ));
            },
            borderRadius: BorderRadius.circular(50),
            widthSearchBar: MediaQuery.of(context).size.width,
            hintText: "Choose your Location",
            fontSize: 12,
            textEditingController: _searchController,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appColor,
        onPressed: _onDoneButtonPressed,
        child: Icon(Icons.done, color: AppTheme.whiteColor),
      ),
    );
  }

  void _onDoneButtonPressed() {
    Navigator.pop(context, _selectedLatLng);
  }

  _searchLocation({String? searchText}) async {
    String apiKey = 'AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$searchText&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        Map<String, dynamic> location =
        data['results'][0]['geometry']['location'];
        print("123810923 ${location}");
        setState(() {
          gotIt = location;
        });
      } else {
        throw Exception('Failed to geocode address: $searchText');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//this screen shows the Big size of Google Map Image.
class LocationImageScreen extends StatelessWidget {
  final LatLng location;

  LocationImageScreen(this.location);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                'https://maps.googleapis.com/maps/api/staticmap?center=${location.latitude},${location.longitude}&zoom=15&size=400x400&markers=color:red%7C${location.latitude},${location.longitude}&key=AIzaSyAtEldlQYJiBycTyxcSJeZAqXsBWd8PTFU',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
///
///


class MapScreen2 extends StatefulWidget {
  final  latitude;
  final  longitude;

  MapScreen2({required this.latitude,required this.longitude});

  @override
  _MapScreenState2 createState() => _MapScreenState2();
}

class _MapScreenState2 extends State<MapScreen2> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    CameraPosition _initialPosition =
    CameraPosition(target: LatLng(widget.latitude, widget.longitude), zoom: 16);

    return Scaffold(

      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          Marker(
            markerId: MarkerId('Marker'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: 'Location',
              snippet: 'Latitude: ${widget.latitude}, Longitude: ${widget.longitude}',
            ),
          ),
        },
      ),
    );
  }
}

