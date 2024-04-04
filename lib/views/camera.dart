import 'package:ai/controller/scan.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            var factorX = width / controller.imgW;
            var factorY = height / controller.imgH;

            return controller.isInit.value
                ? Center(
                    child: Stack(children: [
                      CameraPreview(controller.camroller),
                      Positioned(
                        top: controller.y * (controller.imgH/controller.imgH*width),
                        left: controller.x * width,
                        // top: 0,
                        // right: 0,
                        child: Container(
                          width: controller.w*width,
                          height: controller.h*controller.imgH,
                          // height: 100,
                          // width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 4.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  color: Colors.white,
                                  child: Text("${controller.label}"))
                            ],
                          ),
                        ),
                      ),

                    ]),
                  )
                : Center(child: Text('data'));
          }),
    );
  }
}
