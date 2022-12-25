import 'package:cluedin_app/widgets/customDivider.dart';
import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  ProfileDetails({super.key});
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
            imageProfile(),
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
}

Widget imageProfile() {
  return Center(
    child: Stack(children: <Widget>[
      // CircleAvatar(
      //   radius: 80.0,
      //   backgroundImage: _imageFile == null
      //       ? AssetImage("assets/profile.jpeg")
      //       : FileImage(File(_imageFile.path)),
      // ),
      const CircleAvatar(
        backgroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/88235295?s=400&u=2c6acf95bc514b8ca6115a6ff24822154a10ee7b&v=4'),
        radius: 80,
      ),
      Positioned(
        bottom: 0.0,
        right: 0.0,
        child: InkWell(
          onTap: () {
            // showModalBottomSheet(
            //   context: BuildContext,
            //   builder: ((builder) => bottomSheet()),
            // );
          },
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 29, 29),
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
