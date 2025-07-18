part of '../maplibre_gl_platform_interface.dart';

class MapLibreMethodChannel extends MapLibrePlatform {
  late MethodChannel _channel;
  static bool useHybridComposition = false;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'infoWindow#onTap':
        final String? symbolId = call.arguments['symbol'];
        if (symbolId != null) {
          onInfoWindowTappedPlatform(symbolId);
        }

      case 'feature#onTap':
        final id = call.arguments['id'];
        final double x = call.arguments['x'];
        final double y = call.arguments['y'];
        final double lng = call.arguments['lng'];
        final double lat = call.arguments['lat'];
        final String layerId = call.arguments['layerId'];
        onFeatureTappedPlatform({
          'id': id,
          'point': Point<double>(x, y),
          'latLng': LatLng(lat, lng),
          'layerId': layerId
        });
      case 'feature#onDrag':
        final id = call.arguments['id'];
        final double x = call.arguments['x'];
        final double y = call.arguments['y'];
        final double originLat = call.arguments['originLat'];
        final double originLng = call.arguments['originLng'];

        final double currentLat = call.arguments['currentLat'];
        final double currentLng = call.arguments['currentLng'];

        final double deltaLat = call.arguments['deltaLat'];
        final double deltaLng = call.arguments['deltaLng'];
        final String eventType = call.arguments['eventType'];

        onFeatureDraggedPlatform({
          'id': id,
          'point': Point<double>(x, y),
          'origin': LatLng(originLat, originLng),
          'current': LatLng(currentLat, currentLng),
          'delta': LatLng(deltaLat, deltaLng),
          'eventType': eventType,
        });
      case 'camera#onMoveStarted':
        onCameraMoveStartedPlatform(null);
      case 'camera#onMove':
        final cameraPosition =
            CameraPosition.fromMap(call.arguments['position'])!;
        onCameraMovePlatform(cameraPosition);
      case 'map#onMapReverseLocationCallback':
        final String result_location = call.arguments['result'];
        onMapReverseLocationCallback(result_location);
      case 'camera#onIdle':
        final cameraPosition =
            CameraPosition.fromMap(call.arguments['position']);
        onCameraIdlePlatform(cameraPosition);
      case 'map#onStyleLoaded':
        onMapStyleLoadedPlatform(null);
      case 'map#onMapClick':
        final double x = call.arguments['x'];
        final double y = call.arguments['y'];
        final double lng = call.arguments['lng'];
        final double lat = call.arguments['lat'];
        onMapClickPlatform(
            {'point': Point<double>(x, y), 'latLng': LatLng(lat, lng)});
      case 'map#onMapLongClick':
        final double x = call.arguments['x'];
        final double y = call.arguments['y'];
        final double lng = call.arguments['lng'];
        final double lat = call.arguments['lat'];
        onMapLongClickPlatform(
            {'point': Point<double>(x, y), 'latLng': LatLng(lat, lng)});
      case 'map#onCameraTrackingChanged':
        final int mode = call.arguments['mode'];
        onCameraTrackingChangedPlatform(MyLocationTrackingMode.values[mode]);
      case 'map#onCameraTrackingDismissed':
        onCameraTrackingDismissedPlatform(null);
      case 'map#onIdle':
        onMapIdlePlatform(null);
      case 'map#onUserLocationUpdated':
        final dynamic userLocation = call.arguments['userLocation'];
        final dynamic heading = call.arguments['heading'];
        onUserLocationUpdatedPlatform(UserLocation(
            position: LatLng(
              userLocation['position'][0],
              userLocation['position'][1],
            ),
            altitude: userLocation['altitude'],
            bearing: userLocation['bearing'],
            speed: userLocation['speed'],
            horizontalAccuracy: userLocation['horizontalAccuracy'],
            verticalAccuracy: userLocation['verticalAccuracy'],
            heading: heading == null
                ? null
                : UserHeading(
                    magneticHeading: heading['magneticHeading'],
                    trueHeading: heading['trueHeading'],
                    headingAccuracy: heading['headingAccuracy'],
                    x: heading['x'],
                    y: heading['y'],
                    z: heading['x'],
                    timestamp: DateTime.fromMillisecondsSinceEpoch(
                        heading['timestamp']),
                  ),
            timestamp: DateTime.fromMillisecondsSinceEpoch(
                userLocation['timestamp'])));
      default:
        throw MissingPluginException();
    }
  }

  @override
  Future<void> initPlatform(int id) async {
    _channel = MethodChannel('plugins.flutter.io/maplibre_gl_$id');
    _channel.setMethodCallHandler(_handleMethodCall);
    await _channel.invokeMethod('map#waitForMap');
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      if (useHybridComposition) {
        return PlatformViewLink(
          viewType: 'plugins.flutter.io/maplibre_gl',
          surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
          ) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: gestureRecognizers ??
                  const <Factory<OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final controller = PlatformViewsService.initAndroidView(
              id: params.id,
              viewType: 'plugins.flutter.io/maplibre_gl',
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => params.onFocusChanged(true),
            );

            controller.addOnPlatformViewCreatedListener(
              params.onPlatformViewCreated,
            );
            controller.addOnPlatformViewCreatedListener(
              onPlatformViewCreated,
            );

            controller.create();
            return controller;
          },
        );
      } else {
        return AndroidView(
          viewType: 'plugins.flutter.io/maplibre_gl',
          onPlatformViewCreated: onPlatformViewCreated,
          gestureRecognizers: gestureRecognizers,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.flutter.io/maplibre_gl',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return OhosView(
      // 封装原生组件
        viewType: 'plugins.flutter.io/maplibre_gl', // 这里要与Native侧CustomPlugin中的保持一致
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  @override
  Future<CameraPosition?> updateMapOptions(
      Map<String, dynamic> optionsUpdate) async {
    final dynamic json = await _channel.invokeMethod(
      'map#update',
      <String, dynamic>{
        'options': optionsUpdate,
      },
    );
    return CameraPosition.fromMap(json);
  }

  @override
  Future<bool?> animateCamera(cameraUpdate, {Duration? duration}) async {
    return _channel.invokeMethod('camera#animate', <String, dynamic>{
      'cameraUpdate': cameraUpdate.toJson(),
      'duration': duration?.inMilliseconds,
    });
  }

  @override
  Future<bool?> moveCamera(CameraUpdate cameraUpdate) async {
    return _channel.invokeMethod('camera#move', <String, dynamic>{
      'cameraUpdate': cameraUpdate.toJson(),
    });
  }

  @override
  Future<void> addMarkerAtLatLng_Ohos(LatLng centre, ByteData bytes, double size) async {
    await _channel.invokeMethod('map#addMarkerAtLatLng', <String, dynamic>{
      'longitude': centre.longitude,
      'latitude': centre.latitude,
      'bytes' : bytes.buffer.asUint8List(),
      'iconSize': size
    });
  }

  @override
  Future<LatLng> GCJ02toWGS84_Ohos(LatLng centre) async {
    final coordinate = await _channel.invokeMethod('map#GCJ02toWGS84', <String, dynamic>{
      'longitude': centre.longitude,
      'latitude': centre.latitude
    });

    return LatLng(coordinate['x'], coordinate['y']);
  }

  @override
  Future<void> updateMyLocationTrackingMode(
      MyLocationTrackingMode myLocationTrackingMode) async {
    await _channel
        .invokeMethod('map#updateMyLocationTrackingMode', <String, dynamic>{
      'mode': myLocationTrackingMode.index,
    });
  }

  @override
  Future<void> matchMapLanguageWithDeviceDefault() async {
    await _channel.invokeMethod('map#matchMapLanguageWithDeviceDefault');
  }

  @override
  Future<void> updateContentInsets(EdgeInsets insets, bool animated) async {
    await _channel.invokeMethod('map#updateContentInsets', <String, dynamic>{
      'bounds': <String, double>{
        'top': insets.top,
        'left': insets.left,
        'bottom': insets.bottom,
        'right': insets.right,
      },
      'animated': animated,
    });
  }

  @override
  Future<void> setMapLanguage(String language) async {
    await _channel.invokeMethod('map#setMapLanguage', <String, dynamic>{
      'language': language,
    });
  }

  @override
  Future<void> setTelemetryEnabled(bool enabled) async {
    await _channel.invokeMethod('map#setTelemetryEnabled', <String, dynamic>{
      'enabled': enabled,
    });
  }

  @override
  Future<bool> getTelemetryEnabled() async {
    return await _channel.invokeMethod('map#getTelemetryEnabled');
  }

  @override
  Future<List> queryRenderedFeatures(
      Point<double> point, List<String> layerIds, List<Object>? filter) async {
    try {
      final Map<dynamic, dynamic> reply = await _channel.invokeMethod(
        'map#queryRenderedFeatures',
        <String, Object?>{
          'x': point.x,
          'y': point.y,
          'layerIds': layerIds,
          'filter': filter,
        },
      );
      return reply['features'].map((feature) => jsonDecode(feature)).toList();
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List> queryRenderedFeaturesInRect(
      Rect rect, List<String> layerIds, String? filter) async {
    try {
      final Map<dynamic, dynamic> reply = await _channel.invokeMethod(
        'map#queryRenderedFeatures',
        <String, Object?>{
          'left': rect.left,
          'top': rect.top,
          'right': rect.right,
          'bottom': rect.bottom,
          'layerIds': layerIds,
          'filter': filter,
        },
      );
      return reply['features'].map((feature) => jsonDecode(feature)).toList();
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List> querySourceFeatures(
      String sourceId, String? sourceLayerId, List<Object>? filter) async {
    try {
      final Map<dynamic, dynamic> reply = await _channel.invokeMethod(
        'map#querySourceFeatures',
        <String, Object?>{
          'sourceId': sourceId,
          'sourceLayerId': sourceLayerId,
          'filter': filter,
        },
      );
      return reply['features'].map((feature) => jsonDecode(feature)).toList();
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future invalidateAmbientCache() async {
    try {
      await _channel.invokeMethod('map#invalidateAmbientCache');
      return null;
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future clearAmbientCache() async {
    try {
      await _channel.invokeMethod('map#clearAmbientCache');
      return null;
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<LatLng> requestMyLocationLatLng() async {
    try {
      final Map<dynamic, dynamic> reply =
          await _channel.invokeMethod('locationComponent#getLastLocation');
      var latitude = 0.0;
      var longitude = 0.0;
      if (reply.containsKey('latitude') && reply['latitude'] != null) {
        latitude = double.parse(reply['latitude'].toString());
      }
      if (reply.containsKey('longitude') && reply['longitude'] != null) {
        longitude = double.parse(reply['longitude'].toString());
      }
      return LatLng(latitude, longitude);
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<LatLngBounds> getVisibleRegion() async {
    try {
      final Map<dynamic, dynamic> reply =
          await _channel.invokeMethod('map#getVisibleRegion');
      final southwest = reply['sw'] as List<dynamic>;
      final northeast = reply['ne'] as List<dynamic>;
      return LatLngBounds(
        southwest: LatLng(southwest[0], southwest[1]),
        northeast: LatLng(northeast[0], northeast[1]),
      );
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addImage(String name, Uint8List bytes,
      [bool sdf = false]) async {
    try {
      return await _channel.invokeMethod('style#addImage', <String, Object>{
        'name': name,
        'bytes': bytes,
        'length': bytes.length,
        'sdf': sdf
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addImageSource(
      String imageSourceId, Uint8List bytes, LatLngQuad coordinates) async {
    try {
      return await _channel
          .invokeMethod('style#addImageSource', <String, Object>{
        'imageSourceId': imageSourceId,
        'bytes': bytes,
        'length': bytes.length,
        'coordinates': coordinates.toList()
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> updateImageSource(
      String imageSourceId, Uint8List? bytes, LatLngQuad? coordinates) async {
    try {
      return await _channel
          .invokeMethod('style#updateImageSource', <String, Object?>{
        'imageSourceId': imageSourceId,
        'bytes': bytes,
        'length': bytes?.length,
        'coordinates': coordinates?.toList()
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<Point> toScreenLocation(LatLng latLng) async {
    try {
      final screenPosMap =
          await _channel.invokeMethod('map#toScreenLocation', <String, dynamic>{
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      });
      return Point(screenPosMap['x'], screenPosMap['y']);
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> reverseGeo(LatLng latLng) async {
    try {
        await _channel.invokeMethod('map#reverseGeo', <String, dynamic>{
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<Point>> toScreenLocationBatch(Iterable<LatLng> latLngs) async {
    try {
      final coordinates = Float64List.fromList(latLngs
          .map((e) => [e.latitude, e.longitude])
          .expand((e) => e)
          .toList());
      final Float64List result = await _channel.invokeMethod(
          'map#toScreenLocationBatch', {"coordinates": coordinates});

      final points = <Point>[];
      for (var i = 0; i < result.length; i += 2) {
        points.add(Point(result[i], result[i + 1]));
      }

      return points;
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> removeSource(String sourceId) async {
    try {
      return await _channel.invokeMethod(
        'style#removeSource',
        <String, Object>{'sourceId': sourceId},
      );
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addLayer(String imageLayerId, String imageSourceId,
      double? minzoom, double? maxzoom) async {
    try {
      return await _channel.invokeMethod('style#addLayer', <String, dynamic>{
        'imageLayerId': imageLayerId,
        'imageSourceId': imageSourceId,
        'minzoom': minzoom,
        'maxzoom': maxzoom
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addLayerBelow(String imageLayerId, String imageSourceId,
      String belowLayerId, double? minzoom, double? maxzoom) async {
    try {
      return await _channel
          .invokeMethod('style#addLayerBelow', <String, dynamic>{
        'imageLayerId': imageLayerId,
        'imageSourceId': imageSourceId,
        'belowLayerId': belowLayerId,
        'minzoom': minzoom,
        'maxzoom': maxzoom
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> removeLayer(String imageLayerId) async {
    try {
      return await _channel.invokeMethod(
          'style#removeLayer', <String, Object>{'layerId': imageLayerId});
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> setFilter(String layerId, dynamic filter) async {
    try {
      return await _channel.invokeMethod('style#setFilter',
          <String, Object>{'layerId': layerId, 'filter': jsonEncode(filter)});
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<dynamic> getFilter(String layerId) async {
    try {
      final Map<dynamic, dynamic> reply =
          await _channel.invokeMethod('style#getFilter', <String, dynamic>{
        'layerId': layerId,
      });
      final filter = reply["filter"];
      return filter != null ? jsonDecode(filter) : null;
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<LatLng> toLatLng(Point screenLocation) async {
    try {
      final latLngMap =
          await _channel.invokeMethod('map#toLatLng', <String, dynamic>{
        'x': screenLocation.x,
        'y': screenLocation.y,
      });
      return LatLng(latLngMap['latitude'], latLngMap['longitude']);
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<double> getMetersPerPixelAtLatitude(double latitude) async {
    try {
      final latLngMap = await _channel
          .invokeMethod('map#getMetersPerPixelAtLatitude', <String, dynamic>{
        'latitude': latitude,
      });
      return latLngMap['metersperpixel'];
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addGeoJsonSource(String sourceId, Map<String, dynamic> geojson,
      {String? promoteId}) async {
    await _channel.invokeMethod('source#addGeoJson', <String, dynamic>{
      'sourceId': sourceId,
      'geojson': jsonEncode(geojson),
    });
  }

  @override
  Future<void> setGeoJsonSource(
      String sourceId, Map<String, dynamic> geojson) async {
    await _channel.invokeMethod('source#setGeoJson', <String, dynamic>{
      'sourceId': sourceId,
      'geojson': jsonEncode(geojson),
    });
  }

  @override
  Future setCameraBounds({
    required double west,
    required double north,
    required double south,
    required double east,
    required int padding,
  }) async {
    try {
      await _channel.invokeMethod('map#setCameraBounds', <String, dynamic>{
        'west': west,
        'north': north,
        'south': south,
        'east': east,
        'padding': padding,
      });
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addSymbolLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      required bool enableInteraction}) async {
    await _channel.invokeMethod('symbolLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'sourceLayer': sourceLayer,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'filter': jsonEncode(filter),
      'enableInteraction': enableInteraction,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addLineLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      required bool enableInteraction}) async {
    await _channel.invokeMethod('lineLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'sourceLayer': sourceLayer,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'filter': jsonEncode(filter),
      'enableInteraction': enableInteraction,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> setLayerProperties(
      String layerId, Map<String, dynamic> properties) async {
    await _channel.invokeMethod('layer#setProperties', <String, dynamic>{
      'layerId': layerId,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addCircleLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      required bool enableInteraction}) async {
    await _channel.invokeMethod('circleLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'sourceLayer': sourceLayer,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'filter': jsonEncode(filter),
      'enableInteraction': enableInteraction,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addFillLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      required bool enableInteraction}) async {
    await _channel.invokeMethod('fillLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'sourceLayer': sourceLayer,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'filter': jsonEncode(filter),
      'enableInteraction': enableInteraction,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addFillExtrusionLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom,
      dynamic filter,
      required bool enableInteraction}) async {
    await _channel.invokeMethod('fillExtrusionLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'sourceLayer': sourceLayer,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'filter': jsonEncode(filter),
      'enableInteraction': enableInteraction,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channel.setMethodCallHandler(null);
  }

  @override
  Future<void> addSource(String sourceId, SourceProperties properties) async {
    await _channel.invokeMethod('style#addSource', <String, dynamic>{
      'sourceId': sourceId,
      'properties': properties.toJson(),
    });
  }

  @override
  Future<void> addRasterLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom}) async {
    await _channel.invokeMethod('rasterLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addHillshadeLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom}) async {
    await _channel.invokeMethod('hillshadeLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> addHeatmapLayer(
      String sourceId, String layerId, Map<String, dynamic> properties,
      {String? belowLayerId,
      String? sourceLayer,
      double? minzoom,
      double? maxzoom}) async {
    await _channel.invokeMethod('heatmapLayer#add', <String, dynamic>{
      'sourceId': sourceId,
      'layerId': layerId,
      'belowLayerId': belowLayerId,
      'minzoom': minzoom,
      'maxzoom': maxzoom,
      'properties': properties
          .map((key, value) => MapEntry<String, String>(key, jsonEncode(value)))
    });
  }

  @override
  Future<void> setFeatureForGeoJsonSource(
      String sourceId, Map<String, dynamic> geojsonFeature) async {
    await _channel.invokeMethod('source#setFeature', <String, dynamic>{
      'sourceId': sourceId,
      'geojsonFeature': jsonEncode(geojsonFeature)
    });
  }

  @override
  Future<void> setLayerVisibility(String layerId, bool visible) async {
    await _channel.invokeMethod('layer#setVisibility', <String, dynamic>{
      'layerId': layerId,
      'visible': visible,
    });
  }

  @override
  void forceResizeWebMap() {}

  @override
  void resizeWebMap() {}

  @override
  Future<List> getLayerIds() async {
    try {
      final Map<dynamic, dynamic> reply =
          await _channel.invokeMethod('style#getLayerIds');
      return reply['layers'].map((it) => it.toString()).toList();
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List> getSourceIds() async {
    try {
      final Map<dynamic, dynamic> reply =
          await _channel.invokeMethod('style#getSourceIds');
      return reply['sources'].map((it) => it.toString()).toList();
    } on PlatformException catch (e) {
      return Future.error(e);
    }
  }
}
