import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.096,
          // elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, -5.6, 0),
            child: const Text(
              "Home",
              textAlign: TextAlign.left,
              textScaleFactor: 1.3,
              style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
            ),
          )),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                PageView.builder(
                  itemBuilder: (context, index) {
                    return CarouselCard(
                      car: cars[index],
                    );
                  },
                  itemCount: cars.length,
                  controller:
                      PageController(initialPage: 1, viewportFraction: 1),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
                Positioned(bottom: 0.0, child: updateIndicators()),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          const utilityBar(),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24),
            child: Column(
              children: const <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Student Chapters",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.225,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return ChapterCard();
                },
                itemCount: cars.length,
                controller:
                    PageController(initialPage: 2, viewportFraction: 0.4),
                onPageChanged: (index) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget updateIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cars.map(
          (car) {
            var index = cars.indexOf(car);
            return Container(
              width: 5.0,
              height: 5.0,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.85), //color of border
                  width: 0.5, //width of border
                ),
                shape: BoxShape.circle,
                color: currentPage == index
                    ? const Color.fromARGB(233, 255, 255, 255)
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class utilityBar extends StatelessWidget {
  const utilityBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0.0, 0.75))
        ],
        color: const Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.calendar_today),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Timetable",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.train),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Concession",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.library_books),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Moodle-Elearn",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.web),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Website",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  ChapterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            // child: CachedNetworkImage(
            //   imageUrl: "https://csi.dbit.in/assets/img/CSI-DBIT.png",
            //   fit: BoxFit.cover,
            // ),
            child: Image.asset(
              "assets/images/placeholder.png",
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  CarouselCard({super.key, required this.car});

  TeslaCar car;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: CachedNetworkImage(
            imageUrl: car.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class TeslaCar {
  TeslaCar(
      {required this.model, required this.image, required this.description});

  String model;
  String image;
  String description;
}

var cars = [
  TeslaCar(
      model: 'Roadster',
      image:
          'https://www.itcluster.ck.ua/wp-content/uploads/2019/03/661821a9442a8dbd824e89bd18c0fd2e_XL.jpg',
      description:
          'As an all-electric supercar, Roadster maximizes the potential of aerodynamic engineering—with record-setting performance and efficiency.'),
  TeslaCar(
      model: 'Model S',
      image:
          'https://ictframe.com/wp-content/uploads/Digital-Ocean-Summit-Nepal-2020.jpg',
      description:
          "Model S sets an industry standard for performance and safety. Tesla’s all-electric powertrain delivers unparalleled performance in all weather conditions."),
  TeslaCar(
      model: 'Model 3',
      image:
          'https://stuff.co.za/wp-content/uploads/2021/04/ces-2021-anchor-desk3.jpg_ext-scaled.jpg',
      description:
          "Model 3 comes with the option of dual motor all-wheel drive, 20” Performance Wheels and Brakes and lowered suspension for total control, in all weather conditions."),
  TeslaCar(
      model: 'Model X',
      image:
          'https://www.iottechexpo.com/wp-content/uploads/2018/04/IoT-Tech-Expo-1-777x518.jpg',
      description:
          "Tesla’s all-electric powertrain delivers Dual Motor All-Wheel Drive, adaptive air suspension and the quickest acceleration of any SUV on the road—from zero to 60 mph in 2.6 seconds."),
  TeslaCar(
      model: 'Model Y',
      image:
          'https://www.techtalkthai.com/wp-content/uploads/2016/10/google_DevFest-Hackathon-PR.png',
      description:
          "Tesla All-Wheel Drive has two ultra-responsive, independent electric motors that digitally control torque to the front and rear wheels—for far better handling, traction and stability."),
];
