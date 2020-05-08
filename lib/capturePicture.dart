// A screen that allows users to take a picture using a given camera.
import 'dart:convert';
import 'dart:io';
import 'package:Doctor/patient.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show join;
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final doctor;
  final Patient patient;
  const TakePictureScreen({
    Key key,
    @required this.camera,
    @required this.doctor,
    @required this.patient,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() =>
      TakePictureScreenState(doctor: doctor, patient: patient);
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final doctor;
  final Patient patient;

  TakePictureScreenState({this.doctor, this.patient});
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            String photo_name = doctor.toString() +
                patient.pname.toString() +
                DateFormat("dd_MM_yyyy_HH_MM_SS")
                    .format(DateTime.now())
                    .toString();
            print(photo_name);
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              photo_name + '.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    imagePath: path, patient: patient, photo_name: photo_name),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Patient patient;
  final String photo_name;
  const DisplayPictureScreen(
      {Key key, this.imagePath, this.patient, this.photo_name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(photo_name)),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: ListView(shrinkWrap: true, children: <Widget>[
          Card(
            color: Colors.transparent,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.file(File(imagePath)),
                  RaisedButton(
                    color: Colors.blue,
                    padding: EdgeInsets.only(right: 5),
                    child: Text('Upload'),
                    onPressed: () async {
                      submitAction(context);
                    },
                  )
                ],
              ),
            ),
            margin: EdgeInsets.only(left: 5, right: 5),
          ),
        ]));
  }

  //Image.file(File(imagePath)),
  void submitAction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bearer_token = "Bearer ";
    bearer_token += prefs.getString('jwt');

    File imageFile = File(imagePath);

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://192.168.0.103:3000/doctor/save/prescription");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile =
        http.MultipartFile('file', stream, length, filename: photo_name);
    request.headers['Authorization'] = bearer_token;
    // add file to multipart
    request.files.add(multipartFile);
    request.fields['id'] = patient.serial;
    request.fields['image_title'] = photo_name;

    // send
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('uploaded');
      Navigator.pop(context);
    } else {}
/*
    var image_file  = base64Encode(File(imagePath).readAsBytesSync());
    //print(image_file);
    final http.Response response = await http.post(
      'http://192.168.0.103:3000/doctor/save/prescription',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': bearer_token,
      },
      body: jsonEncode({
        'id': patient.serial,
        'image_title':photo_name,
        'file': image_file  
        }),
      // body: jsonEncode({'name': _name.text, 'password': _pass.text, "email": _email.text, "institution": _institution.text,"designation": _designation.text,"mobile_no": _mobileNo.text, "reg_number" : _reg_number.text}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('uploaded');
      Navigator.pop(context);
    } else {
      
    }*/
  }
}
