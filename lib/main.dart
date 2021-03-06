import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<_MapPageState> _mapPageStateKey = GlobalKey<_MapPageState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Marker Popup Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.transparent,
        ),
        home: MapPage(_mapPageStateKey),
        debugShowCheckedModeBanner: false,
        builder: (context, navigator) {
          return Scaffold(
            appBar: AppBar(
              title: Text("MapBox/PopUpMaker/UserLocation"),
              centerTitle: true,
            ),
            body: navigator,
          );
        });
  }
}

class MapPage extends StatefulWidget {
  MapPage(GlobalKey<_MapPageState> key) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final List<LatLng> _points = [
    LatLng(44.421, 10.404),
    LatLng(45.683, 10.839),
    LatLng(45.246, 5.783),
  ];

  static const _markerSize = 30.0;
  List<Marker> _markers;
  final zoom = 5;

  // Used to trigger showing/hiding of popups.

  @override
  void initState() {
    super.initState();
    _markers = _points
        .map(
          (LatLng point) => Marker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (BuildContext context) => IconButton(
                icon: Icon(Icons.location_on),
                iconSize: _markerSize,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            // height: 250,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)) ,
                                      child: Image.network("https://source.unsplash.com/random/150x84/?2")
                                    ),
                                    SizedBox(width: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)) ,
                                      child: Image.network("https://source.unsplash.com/random/150x84/?1")
                                    ),
                                    SizedBox(width: 5),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(5)) ,
                                      child: Image.network("https://source.unsplash.com/random/150x84/?3")
                                    )
                                    ]
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    "Titre du Souvenir",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "SomeWhere",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic
                                      ),
                                    ),
                                    Text(
                                      "99/99/2020",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        );
                      });
                }),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();
  }

  // ADD THIS
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  // ADD THIS
  List<Marker> markers = [];

  void zoomButton() {
    mapController.move(LatLng(35, 35), 5); //ZoomTo New LatLng and Zooming
  }

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
        context: context,
        mapController: mapController,
        markers: markers,
        updateMapLocationOnPositionChange: false,
        showMoveToCurrentLocationFloatingActionButton: false);
    return Stack(
      children: [
        FlutterMap(
          options: new MapOptions(
            center: LatLng(46.611182, 2.436257),
            zoom: 5.0,
            plugins: [
              UserLocationPlugin(),
            ],
          ),
          layers: [MarkerLayerOptions(markers: markers), userLocationOptions],
          children: [
            TileLayerWidget(
                options: TileLayerOptions(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/antonin06/ckfnx5e3j05m019s0o8pjvs60/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW50b25pbjA2IiwiYSI6ImNrZm53ejI3NDBsbGQycnM1YXlsYzhtNTcifQ.IrQsUXT8P7nQZpkwuDtPjw',
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoiYW50b25pbjA2IiwiYSI6ImNrZm53ejI3NDBsbGQycnM1YXlsYzhtNTcifQ.IrQsUXT8P7nQZpkwuDtPjw',
                'id': 'mapbox.satellite'
              },
            )),
            MarkerLayerWidget(options: MarkerLayerOptions(markers: _markers)),
          ],
        ),
      ],
    );
  }


  // void showPopupForFirstMarker() {
  //   _popupLayerController.togglePopup(_markers.first);
  // }
}
