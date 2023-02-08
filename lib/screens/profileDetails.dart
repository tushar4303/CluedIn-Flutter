import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _imageFile;
  final _picker = ImagePicker();
  late String _imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.076,
          elevation: 0.3,
          title: const Text(
            "Account",
            textScaleFactor: 1.3,
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            imageProfile(context),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Name",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      "Tushar Padhy",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Phone",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      "8104951731",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.mail),
                    title: Text("Email",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      "padhytushar4303@gmail.com",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text("Branch",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      "IT",
                      textScaleFactor: 1.2,
                      style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        )));
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          backgroundImage: _imageURL == null
              ? const NetworkImage(
                  "https://avatars.githubusercontent.com/u/88235295?v=4")
              : NetworkImage(_imageURL),
          radius: 80,
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  isScrollControlled: false,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (builder) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        //content starts
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 5.0, left: 24.0, top: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // rounded rectangle grey handle

                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Profile photo",
                                  textScaleFactor: 1.4,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async =>
                                            _pickImageFromCamera(),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 30, 29, 29),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            semanticLabel: "Camera",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Camera"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async =>
                                            _pickImageFromGallery(),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 30, 29, 29),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Icon(
                                            Icons.image,
                                            semanticLabel: "Gallery",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("Gallery"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 30, 29, 29),
                  borderRadius: BorderRadius.circular(24)

                  //more than 50% of width makes circle
                  ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future uploadImage(File _image) async {
    // Compress the image
    var image = img.decodeImage(_image.readAsBytesSync());
    var compressImage = img.copyResize(image!, width: 500, height: 500);

    // Encode the compressed image as a PNG
    var pngBytes = img.encodePng(compressImage);

    // Get the path for storing the compressed image on the device
    var dir = await getTemporaryDirectory();
    var file = File("${dir.path}/compressed_image.png");

    // Write the PNG bytes to the file
    await file.writeAsBytes(pngBytes);

    // Create the multipart form data
    var url = "YOUR_API_URL";
    var mobno = "8104951731";
    var request = http.MultipartRequest("POST", Uri.parse(url));

    // Create a MultipartFile from the compressed image
    var fileData = await file.readAsBytes();
    var fileMultipartFile = http.MultipartFile.fromBytes(
      'image',
      fileData,
      filename: 'compressed_image.png',
      contentType: MediaType.parse(lookupMimeType('png')!),
    );

    request.files.add(fileMultipartFile);
    request.fields["mobno"] = mobno;

    // Send the multipart form data request
    var response = await request.send();

    // Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    // Check the status code of the response
    if (response.statusCode == 200) {
      // Parse the response to get the image URL
      var responseJSON = json.decode(responseString);
      var imageURL = responseJSON["image_url"];

      // Update the _imageURL variable with the new URL
      setState(() {
        _imageURL = imageURL;
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to upload image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
      uploadImage(_imageFile!);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
      uploadImage(_imageFile!);
    }
  }
}
