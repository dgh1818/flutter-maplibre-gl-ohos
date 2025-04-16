import { MapComponent, mapCommon, map} from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit'
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { BinaryMessenger,
  MessageCodec,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  PlatformView, PlatformViewFactory,
  StandardMethodCodec } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { Convert } from './Convert'
import { MapLibreMapOptionsSink } from './MapLibreMapOptionsSink'
import { MapLibreMapController } from './MapLibreMapController'
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
// @Observed      //相当于widgetView
// export class MapLibreMapController extends PlatformView implements MethodCallHandler{
//   TAG: string = "MapLibreMapController";
//   public mapController?: map.MapComponentController;
//   public mapEventManager?: map.MapEventManager; // 存储事件管理器
//   longitude: number = 39.9;
//   latitude: number = 116.4;
//   methodChannel:MethodChannel;
//   context?: common.Context;
//   viewId?: number;
//   args?: Object;
//   //private var mapView: MLNMapView
//   isMapReady:boolean = false;
//   dragEnabled:boolean = true;
//   isFirstStyleLoad:boolean = true;
//   onStyleLoadedCalled:boolean = false;
//   mapReadyResult?: MethodResult;
//   // private var previousDragCoordinate: CLLocationCoordinate2D?
//   // private var originDragCoordinate: CLLocationCoordinate2D?
//   // private var dragFeature: MLNFeature?
//   //
//   // private var initialTilt: CGFloat?
//   cameraTargetBounds?: mapCommon.LatLngBounds
//   trackCameraPosition:boolean = false;
//   myLocationEnabled:boolean = false;
//   scrollingEnabled:boolean = true;
//   args_input:Map<string,ESObject>;
//   args_options:ESObject;
//   private callback?: AsyncCallback<map.MapComponentController>;
//   //mapcom:MapComponent;
//
//
//   constructor(context: common.Context, viewId: number, args: ESObject, message: BinaryMessenger) {
//     super();
//     // 注册消息通道
//     this.methodChannel = new MethodChannel(message, `plugins.flutter.io/maplibre_gl_${viewId}`, StandardMethodCodec.INSTANCE);
//     this.methodChannel.setMethodCallHandler(this);
//     console.error("set methodchannel success");
//     this.mapController = new map.MapComponentController;
//
//     this.args_input = args as Map<string,ESObject>;
//     this.args_options = this.args_input.get("options");
//     // this.args_input.forEach((value:ESObject,key:string) => {
//     //   console.error(key);
//     //   console.error("value size is " + value.size);
//     //   // if(args_input.get())。
//     //   console.error(typeof (this.args_input.get(key)));
//     // })
//
//
//
//     // if dragEnabled {
//     //   let pan = UIPanGestureRecognizer(
//     //     target: self,
//     //   action: #selector(handleMapPan(sender:))
//     //   )
//     //   pan.delegate = self
//     //   mapView.addGestureRecognizer(pan)
//     // }
//     //
//     // if(!longPressRecognizerAdded) {
//     //   mapView.addGestureRecognizer(longPress)
//     //   longPressRecognizerAdded = true
//     //}
//   }
//
//   // public init(options: ESObject, delegate:MapLibreMapController) {
//   //   Convert.interpretMapLibreMapOptions(options,this)
//   //   Convert.interpretMapLibreMapOptions.call
//   // }
//   // public setMapController(mapController: map.MapComponentController):void {
//   //   console.error("enter setMapController success")
//   //   this.mapController = mapController;
//   //   console.error("leave setMapController success")
//   // }
//
//   public setCameraTargetBounds(bounds:mapCommon.LatLngBounds):void {
//     this.cameraTargetBounds = bounds;
//     this.mapController!.setLatLngBounds(this.cameraTargetBounds);
//   }
//
//   // static interpretMapLibreMapOptions = (options: ESObject, delegate:MapLibreMapOptionsSink) =>
//   public setCompassEnabled (compassEnabled:boolean):void {
//     console.error("enter setCompassEnabled controller");
//     this.mapController!.setCompassControlsEnabled(compassEnabled);
//     console.error("leave setCompassEnabled controller");
//   }
//
//   public setMinMaxZoomPreference(min?:number, max?:number):void {
//     this.mapController?.setMinZoom(min);
//     this.mapController?.setMaxZoom(max);
//   }
//
//   public setStyleString(styleString:string):void {
//     if (styleString.length == 0)
//       console.log("setStyleString - string empty");
//     else if (styleString.startsWith("{") || styleString.startsWith("[")) {
//       console.log("setStyleString - JSON style currently not supported");
//       // Currently the iOS MapLibre SDK does not have a builder for json.
//
//     } else if (!isNaN(parseInt(styleString))) {
//
//       let styleType: mapCommon.CustomMapStyleOptions = {
//         styleId: "parseInt(styleString)"
//       };
//       this.mapController?.setCustomMapStyle(styleType);
//     } else {
//       // Absolute path
//       console.log("setStyleString - Absolute path currently not supported");
//     }
//   }
//   //
//   // fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean)
//   public setRotateGesturesEnabled(rotateGesturesEnabled:boolean):void {
//     this.mapController?.setRotateGesturesEnabled(rotateGesturesEnabled);
//   }
//   //
//   // fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean)
//   public setScrollGesturesEnabled(scrollGesturesEnabled:boolean):void {
//     this.mapController?.setScrollGesturesEnabled(scrollGesturesEnabled);
//     this.scrollingEnabled = scrollGesturesEnabled
//   }
//   //
//   // fun setTiltGesturesEnabled(tiltGesturesEnabled: Boolean)
//   public setTiltGesturesEnabled(tiltGesturesEnabled:boolean):void {
//     this.mapController?.setTiltGesturesEnabled(tiltGesturesEnabled);
//   }
//
//   public setTrackCameraPosition(trackCameraPosition:boolean):void {
//     this.trackCameraPosition = trackCameraPosition;
//   }
//
//   public setZoomGesturesEnabled(zoomGesturesEnabled:boolean):void {
//     this.mapController?.setZoomControlsEnabled(zoomGesturesEnabled);
//   }
//
//   public setMyLocationEnabled(myLocationEnabled:boolean):void {
//     if (this.myLocationEnabled == myLocationEnabled) {
//       return
//     }
//     this.myLocationEnabled = myLocationEnabled
//     this.updateMyLocationEnabled()
//   }
//
//   private updateMyLocationEnabled():void{
//     this.mapController?.setMyLocationEnabled(this.myLocationEnabled);
//   }
//
//   public setMyLocationTrackingMode(myLocationTrackingMode:mapCommon.MyLocationDisplayType):void {
//     let style: mapCommon.MyLocationStyle = {
//       displayType: myLocationTrackingMode
//     };
//
//     this.mapController?.setMyLocationStyle(style);
//   }
//   //未找到对应
//   public setMyLocationRenderMode(myLocationRenderMode:mapCommon.MyLocationDisplayType):void {
//     let style: mapCommon.MyLocationStyle = {
//       displayType: myLocationRenderMode
//     };
//
//     this.mapController?.setMyLocationStyle(style);
//   }
//   //未找到对应
//   public setLogoViewMargins(x:number, y:number):void {
//     let padding: mapCommon.Padding = {
//       left: x,
//       bottom: y
//     };
//
//     this.mapController?.setLogoPadding(padding);
//   }
//
//   public setCompassViewPosition(position: number):void {
//     console.log("setCompassViewPosition - OHOS not supported");
//   }
//
//   public setCompassViewMargins(x:number, y:number):void {
//     let point: mapCommon.MapPoint = {
//       positionX: x,
//       positionY: y
//     };
//     this.mapController?.setCompassPosition(point)
//   }
//
//   public setAttributionButtonMargins(x:number,y:number):void {
//     console.log("setAttributionButtonMargins - OHOS not supported");
//   }
//
//   public setAttributionButtonPosition(position:number):void {
//     console.log("setAttributionButtonPosition - OHOS not supported");
//   }
//
//   // public toLatLngBounds(o: number[][]): mapCommon.LatLngBounds {
//   //   // if (o == null) {
//   //   //   return null;
//   //   // }
//   //   console.error("enter toLatLngBounds");
//   //   let southwest_data: mapCommon.LatLng = {
//   //     latitude: o[0][0],
//   //     longitude: o[0][1]
//   //   };
//   //
//   //   let northeast_data: mapCommon.LatLng = {
//   //     latitude: o[1][0],
//   //     longitude: o[1][1]
//   //   };
//   //
//   //   let CoordinateBounds:mapCommon.LatLngBounds = {
//   //     northeast: northeast_data,
//   //     southwest: southwest_data
//   //   }
//   //
//   //   console.error("leave toLatLngBounds");
//   //
//   //   return CoordinateBounds
//   // }
//
//   public init():void {
//
//     // let options_converted:Map<string,ESObject> = this.args_options as Map<string,ESObject>;
//     // if(options_converted == undefined) {
//     //   console.error("options_converted undefined");
//     //   return;
//     // }
//
//     if(this.args_input.get('options') == undefined) {
//       console.error("this.args_input is undefined");
//     } else {
//       Convert.interpretMapLibreMapOptions(this.args_options,this)
//       console.error("interpretMapLibreMapOptions ok");
//
//       if(this.args_input.get("initialCameraPosition") != undefined) {
//         let initialCameraPosition:Map<string,ESObject> = this.args_input.get("initialCameraPosition") as Map<string,ESObject>;
//         let target = initialCameraPosition.get("target") as number[];
//         let zoom = initialCameraPosition.get("zoom") as number;
//         let tilt = initialCameraPosition.get("tilt") as number;    //倾斜角
//         let bearing = initialCameraPosition.get("bearing") as number;
//         if(bearing == null) {
//           bearing = 0;
//         }
//         let latitude = target[0]
//         let longitude = target[1]
//         if(target == null && zoom == null && tilt == null) {
//           let cameraPosition: mapCommon.CameraPosition = {
//             target: {
//               latitude: latitude,
//               longitude: longitude
//             },
//             zoom: zoom,
//             tilt: tilt,
//             bearing: bearing
//           };
//
//           let cameraUpdate: map.CameraUpdate = map.newCameraPosition(cameraPosition);
//           this.mapController?.moveCamera(cameraUpdate);
//         }
//
//         if(this.args_input.get("dragEnabled")){
//           let enabled = this.args_input.get("dragEnabled") as boolean;
//           this.dragEnabled = enabled;
//         }
//       }
//
//       // Convert.interpretMapLibreMapOptions(args["options"],this)
//       // console.error("interpretMapLibreMapOptions ok");
//
//
//
//       // if let iosLongClickDurationMilliseconds = args["iosLongClickDurationMilliseconds"] as? Int {
//       //   longPress.minimumPressDuration = TimeInterval(iosLongClickDurationMilliseconds) / 1000
//       //   mapView.addGestureRecognizer(longPress)
//       //   longPressRecognizerAdded = true
//       // }
//
//     }
//
//
//
//
//     console.error("interpretMapLibreMapOptions enter30");
//     // let value:ESObject;
//     // let key:String;
//     // options_converted.forEach((value:ESObject,key:string) => {
//     //   console.error("current convert key is" + key);
//     //   switch (key) {
//     //     case 'cameraTargetBounds':
//     //       console.error("interpretMapLibreMapOptions enter11");
//     //       //console.error(value.size());
//     //       let cameraTargetBounds:number[][][] = value as number[][][];
//     //       console.error("interpretMapLibreMapOptions enter12");
//     //       let input_args:number[][] = cameraTargetBounds[0] as number[][];
//     //       this.setCameraTargetBounds(this.toLatLngBounds(input_args));
//     //       console.error("interpretMapLibreMapOptions enter9");
//     //       break;
//     //     case 'compassEnabled':
//     //       let compassEnabled = value as boolean;
//     //       if(compassEnabled !=undefined) {
//     //         console.error("enter compassEnabled");
//     //         console.error(typeof (value));
//     //         this.setCompassEnabled(value);
//     //         console.error("leave compassEnabled");
//     //       }
//     //       break;
//     //     case 'minMaxZoomPreference':
//     //       let minMaxZoomPreference = options_converted.get("minMaxZoomPreference") as number[];
//     //       this.setMinMaxZoomPreference(minMaxZoomPreference[0],minMaxZoomPreference[1]);
//     //       break;
//     //     case 'rotateGesturesEnabled':
//     //       let rotateGesturesEnabled = options_converted.get("rotateGesturesEnabled") as boolean;
//     //       this.setRotateGesturesEnabled(rotateGesturesEnabled);
//     //       break;
//     //     case 'scrollGesturesEnabled':
//     //       let scrollGesturesEnabled = options_converted.get("scrollGesturesEnabled") as boolean;
//     //       this.setScrollGesturesEnabled(scrollGesturesEnabled);
//     //       break;
//     //     case 'tiltGesturesEnabled':
//     //       let tiltGesturesEnabled = options_converted.get("tiltGesturesEnabled") as boolean;
//     //       this.setTiltGesturesEnabled(tiltGesturesEnabled);
//     //       break;
//     //     case 'trackCameraPosition':
//     //       let trackCameraPosition = options_converted.get("trackCameraPosition") as boolean;
//     //       //self.trackCameraPosition = trackCameraPosition
//     //       this.setTrackCameraPosition(trackCameraPosition);
//     //       break;
//     //     case 'tiltGesturesEnabled':
//     //       let zoomGesturesEnabled = options_converted.get("zoomGesturesEnabled") as boolean;
//     //       this.setZoomGesturesEnabled(zoomGesturesEnabled);
//     //       break;
//     //     case 'myLocationEnabled':
//     //       let myLocationEnabled = options_converted.get("myLocationEnabled") as boolean;
//     //       this.setMyLocationEnabled(myLocationEnabled);
//     //       break;
//     //     case 'myLocationTrackingMode':
//     //       let myLocationTrackingMode = options_converted.get("myLocationTrackingMode") as mapCommon.MyLocationDisplayType;
//     //       this.setMyLocationTrackingMode(myLocationTrackingMode);
//     //       break;
//     //     case 'logoViewMargins':
//     //       let logoViewMargins = options_converted.get("logoViewMargins") as number[];
//     //       this.setLogoViewMargins(logoViewMargins[0], logoViewMargins[1]);
//     //       break;
//     //     case 'compassViewPosition':
//     //       let compassViewPosition = options_converted.get("compassViewPosition") as number;
//     //       this.setCompassViewPosition(compassViewPosition);
//     //       break;
//     //     case 'compassViewMargins':
//     //       let compassViewMargins = options_converted.get("compassViewMargins") as number[];
//     //       this.setCompassViewMargins(compassViewMargins[0],compassViewMargins[1]);
//     //       break;
//     //     case 'attributionButtonMargins':
//     //       let attributionButtonMargins = options_converted.get("attributionButtonMargins") as number[];
//     //       this.setAttributionButtonMargins(attributionButtonMargins[0],attributionButtonMargins[1]);
//     //       break;
//     //   }
//     // })
//
//
//   }
//
//
//   onMethodCall(call: MethodCall, result: MethodResult): void {
//     // 接受Dart侧发来的消息
//     let method: string = call.method;
//     //let link1: SubscribedAbstractProperty<number> = AppStorage.link('numValue');
//     let projection: map.Projection;
//     switch (method) {
//       case 'map#addMarkerAtLatLng':
//         let coordinate2: ESObject = call.args;
//         let longitude2: number = coordinate2['longitude'] as number;
//         let latitude2: number = coordinate2['latitude'] as number;
//         let file = call.args["path"] as string;
//
//         let markerOptions: mapCommon.MarkerOptions = {
//           position: {
//             latitude: latitude2,
//             longitude: longitude2
//           },
//           rotation: 0,
//           visible: true,
//           zIndex: 0,
//           alpha: 1,
//           anchorU: 0.5,
//           anchorV: 1,
//           clickable: false,
//           draggable: false,
//           flat: false,
//           // 图标存放在resources/rawfile
//           icon: file
//         };
//
//         this.mapController?.addMarker(markerOptions);
//         result.success({});
//         break;
//
//       case "map#getVisibleRegion":
//         //var reply = [String: NSObject]()
//         projection = this.mapController!.getProjection();
//         let visibleRegion:mapCommon.VisibleRegion = projection.getVisibleRegion();
//         let reply_sw: ESObject = [visibleRegion.nearLeft.latitude, visibleRegion.nearLeft.longitude] as ESObject
//         let reply_ne: ESObject = [visibleRegion.farRight.latitude, visibleRegion.farRight.longitude] as ESObject
//         result.success({
//           "sw": reply_sw,
//           "ne": reply_ne
//         });
//         break;
//       case "map#toScreenLocation":
//         let coordinate: ESObject = call.args;
//         let longitude: number = coordinate['longitude'] as number;
//         let latitude: number = coordinate['latitude'] as number;
//         let currentPoint: mapCommon.MapPoint = {
//           positionX: longitude,
//           positionY: latitude
//         };
//         projection = this.mapController!.getProjection();
//         let latLng: mapCommon.LatLng = projection.fromScreenLocation(currentPoint);
//
//         result.success({
//           latitude: latLng.latitude,
//           longitude: latLng.longitude
//         });
//         break;
//       // case "style#addImageSource":
//       //   //let argument:ESObject = call.args as ESObject;
//       //   let imageSourceId = call.args["imageSourceId"] as String
//       //   let bytes = call.args["bytes"] as Uint8Array
//       //   //bytes.buffer
//       //   let image_data: image.ImageSource = image.createImageSource(bytes.buffer);
//       //   let width:number
//       //   let height:number
//       //   let new_width:number
//       //   let desired_size:image.Size
//       //   let decodingOptions: image.DecodingOptions
//       //   let pixelmap:PixelMap
//       //   //imageSourceApi.getImageInfo(0, (error: BusinessError, imageInfo: image.ImageInfo) => {
//       //   image_data.getImageInfo(0)
//       //     .then((imageInfo: image.ImageInfo) => {
//       //       width = imageInfo.size.width;
//       //       height = imageInfo.size.height;
//       //       new_width = width / height * call.argument("length") ;
//       //       desired_size.height = call.argument("length");
//       //       desired_size.width = call.argument("new_width");
//       //       decodingOptions = {
//       //         desiredSize:desired_size,
//       //       }
//       //
//       //       image_data.createPixelMap().then((pixelMap: image.PixelMap) => {
//       //         pixelmap = pixelMap;
//       //         console.info('Succeeded in creating pixelMap object through image decoding parameters.');
//       //       })
//       //     }).catch((error: BusinessError) => {
//       //     console.error(`Failed to obtain the image information.code is ${error.code}, message is ${error.message}`);
//       //   })
//       //
//       //   let context = this.context;
//       //   let resourceManager = context!.resourceManager;
//
//       //let map:Resource
//
//       //     image_data.createPixelMap()
//       //
//       //     //image_info.size
//       //     this.style?.add
//       //     this.style?.addImage(
//       //       call.args("name"),
//       //       pixelmap!,
//       //     );
//
//       // result.success(null);
//       // break;
//     }
//
//     // let imageOverlayParams: mapCommon.ImageOverlayParams = {
//     //   image: image_data,
//     //   height: call.args("length")
//     // };
//     // let imageOverlay = this.mapController?.addImageOverlay(imageOverlayParams);
//     // result.success({});
//     // call.argument("name"),
//     // BitmapFactory.decodeByteArray(call.argument("bytes"), 0, call.argument("length")),
//     // call.argument("sdf"));
//     // this.a3a?.addImage(
//     //   call.args["name"],
//     //   image.createPixelMap(image_data)
//     // )
//
//
//     //guard let image = UIImage(data: data) else { return }
//
//     //guard let coordinates = arguments["coordinates"] as? [[Double]] else { return }
//
//   }
//   // getView(): PlatformViewWrapper
//   getView(): WrappedBuilder<[Params]> {
//     return new WrappedBuilder(MapOhosMapBuilder)
//   }
//
//   public getController(): map.MapComponentController {
//     return this.mapController!;
//   }
//
//
//
//   dispose(): void {
//   }
//
//   // private var interactiveFeatureLayerIds = Set<String>()
//   // private var addedShapesByLayer = [String: MLNShape]()
//   // /**
//   //  * This container is returned as the final platform view instead of returning `mapView`.
//   //  * See {@link MapLibreMapController#destroyMapViewIfNecessary()} for details.
//   //  */
//   // private FrameLayout mapViewContainer;
//   // private mapView:MapView;
//   // private MapLibreMap mapLibreMap;
//   // private boolean myLocationEnabled = false;
//   // private int myLocationTrackingMode = 0;
//   // private int myLocationRenderMode = 0;
//   // private boolean disposed = false;
//   // private boolean dragEnabled = true;
//   // private LocationComponent locationComponent = null;
//   // private LocationEngineCallback<LocationEngineResult> locationEngineCallback = null;
//   // private Style style;
//   // private Feature draggedFeature;
//   // private AndroidGesturesManager androidGesturesManager;
//   //
//   // private LatLng dragOrigin;
//   // private LatLng dragPrevious;
//   //
//   // private Set<String> interactiveFeatureLayerIds;
//   // private Map<String, FeatureCollection> addedFeaturesByLayer;
//   //
//   // private LatLngBounds bounds = null;
// }

@Component
export struct MapOhosMap {
  @Prop params: Params;
  //@ObjectLink mapLibreMapController:MapLibreMapController;
  mapController?:map.MapComponentController;

  private TAG = "MapOhosMap";
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  //public mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;

  mapLibreMapController:MapLibreMapController = this.params.platformView as MapLibreMapController

  aboutToAppear(): void {
    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOptions = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 10
      }
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapLibreMapController!.mapController = mapController;
        this.mapLibreMapController!.init();
        this.mapEventManager = this.mapController.getEventManager();
        let callback = () => {
          console.info(this.TAG, `on-mapLoad`);
        }
        this.mapEventManager.on("mapLoad", callback);
      }
    };
  }

  build() {
    Stack() {
      // 调用MapComponent组件初始化地图
      MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback }).width('100%').height('100%')
    }.height('100%')
  }
}

@Builder
export function MapOhosMapBuilder(params: Params) { // 需要通过@Builder的方式来导出原生组件
  MapOhosMap({ params: params })   // 注意这里的params参数必不可少
}
