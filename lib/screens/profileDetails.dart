import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path/path.dart';
// import 'package:async/async.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/profile.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key, required this.userDetails});
  final UserDetails userDetails;

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _imageFile;
  final _picker = ImagePicker();
  String serverUrl = "http://cluedin.creast.in:5000/";
  late String _imageURL = widget.userDetails.profilePic;

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
                children: [
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Name",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      "${widget.userDetails.fname} ${widget.userDetails.lname}",
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text("Phone",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      widget.userDetails.mobno,
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.mail),
                    title: const Text("Email",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      widget.userDetails.email,
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text("Branch",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: Color.fromRGBO(134, 134, 134, 1),
                        )),
                    subtitle: Text(
                      widget.userDetails.branchName,
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 30, 29, 29)),
                    ),
                  ),
                  const Divider(),
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
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
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
    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/${DateTime.now()}.png';

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      _image.absolute.path,
      quality: 50,
    );

    // Write the PNG bytes to the file
    // await file.writeAsBytes(pngBytes);
    File compressedImageFile = File(filePath)
      ..writeAsBytesSync(compressedBytes!);

    // Create the multipart form data
    var url = "http://cluedin.creast.in:5000/api/app/updateProfile";
    var mobno = "8104951731";
    var request = http.MultipartRequest("POST", Uri.parse(url));

    // Create a MultipartFile from the compressed image
    var fileData = compressedImageFile.readAsBytesSync();
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

      var imageURL = serverUrl + responseJSON["img_url"];

      // Update the _imageURL variable with the new URL
      setState(() {
        _imageURL = imageURL;
        Hive.box('userBox').put('profilePic', imageURL);
      });
      Fluttertoast.showToast(
        msg: "Image updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
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
      setState(() => _imageFile = File(pickedFile.path));
      uploadImage(_imageFile!);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      uploadImage(_imageFile!);
    }
  }
}
