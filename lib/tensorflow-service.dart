import 'dart:async';

import 'package:camera/camera.dart';
// import 'flutter_tflite/lib/tflite.dart';
import 'package:tflite/tflite.dart';

// singleton class used as a service
class TensorflowService {
  // singleton boilerplate
  static final TensorflowService _tensorflowService = TensorflowService._internal();

  factory TensorflowService() {
    return _tensorflowService;
  }
  // singleton boilerplate
  TensorflowService._internal();

  StreamController<List<dynamic>> _recognitionController = StreamController();
  Stream get recognitionStream => this._recognitionController.stream;

  bool _modelLoaded = false;

  Future<void> loadModel() async {
    print('load modell');
    try {
      this._recognitionController.add([]);
      await Tflite.loadModel(
        model: "assets/tflite/food_classifier.tflite",
        // model: "assets/tflite/mobilenet_v1_1.0_224.tflite",
        labels: "assets/tflite/labels.txt",
      );
      _modelLoaded = true;
    } catch (e) {
      print('error loading model');
      print(e);
    }
  }

  Future<String?> runModel(CameraImage img) async {
    if (_modelLoaded) {
      List? recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(), // required
        imageHeight: img.height,
        imageWidth: img.width,
        numResults: 3,
        threshold: 0.5
      );
      // shows recognitions on screen
      if (recognitions!.isNotEmpty) {
        print("recognitoonnnn");
        print(recognitions[0].toString());
        print(recognitions[0]['label']);
        if (this._recognitionController.isClosed) {
          // restart if was closed
          this._recognitionController = StreamController();
        }
        // notify to listeners
        this._recognitionController.add(recognitions);
        return recognitions.toString();
      }
      else{
        return "Malay";
      }

    }
  }

  Future<void> stopRecognitions() async {
    if (!this._recognitionController.isClosed) {
      this._recognitionController.add([]);
      this._recognitionController.close();
    }
  }

  void dispose() async {
    this._recognitionController.close();
  }
}
