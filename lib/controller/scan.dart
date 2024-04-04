import 'dart:math';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCam();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    camroller.dispose();
  }

  late CameraController camroller;
  late List<CameraDescription> cams;
  var isInit = false.obs;
  var camCount = 0;
  var x = 0.0, y = 0.0, w = 0.0, h = 0.0;

  var label = '';
  var imgH = 0;
  var imgW = 0;
  var detector;
  initCam() async {
    if (await Permission.camera.request().isGranted) {
      cams = await availableCameras();
      camroller = await CameraController(cams[0], ResolutionPreset.high);
      await camroller.initialize().then((value) {
        camroller.startImageStream((image) {
          camCount++;
          if (camCount % 30 == 0) {
            objDetector(image);
            camCount = 0;
          }
          update();
        });
      });
      isInit(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  initTflite() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/labels.txt",
    );
  }

  objDetector(CameraImage img) async {
    detector = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) => plane.bytes).toList(),
      model: "SSDMobileNet",
      asynch: true,
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      rotation: 90,
      threshold: 0.4,
    );

    if (detector != null && detector.isNotEmpty) {
      if (detector[0]['confidenceInClass'] * 50 > 0) {
        label = detector[0]['detectedClass'].toString();
        x = detector[0]['rect']['x'];
        y = detector[0]['rect']['y'];
        h = detector[0]['rect']['h'];
        w = detector[0]['rect']['w'];
      }
    } else {
      print('No objects detected.');
    }
    imgH = img.height;
    update();
  }
}
