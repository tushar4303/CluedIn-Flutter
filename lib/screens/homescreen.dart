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
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return CarouselCard(
                    car: cars[index],
                  );
                },
                itemCount: cars.length,
                controller: PageController(initialPage: 1, viewportFraction: 1),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
          ),
          updateIndicators(),
          utilityBar(),
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
          )
        ],
      ),
    );
  }

  Widget updateIndicators() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cars.map(
          (car) {
            var index = cars.indexOf(car);
            return Container(
              width: 6.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color(0xFFA6AEBD),
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
              offset: Offset(0.0, 0.75))
        ],
        color: Color.fromRGBO(250, 250, 250, 1),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.black12, //color of border
                    width: 0.15, //width of border
                  ),
                  color: Color.fromRGBO(242, 242, 242, 1)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  iconSize: 38,
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  // tooltip: 'Increase volume by 10',
                  onPressed: () async {
                    final url = Uri.parse(
                        'https://elearn.dbit.in/pluginfile.php/4006/mod_resource/content/1/DSA_CScheme_Syllabus.pdf');
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.black12, //color of border
                    width: 0.15, //width of border
                  ),
                  color: Color.fromRGBO(242, 242, 242, 1)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  iconSize: 38,
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
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.black12, //color of border
                    width: 0.15, //width of border
                  ),
                  color: Color.fromRGBO(242, 242, 242, 1)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  iconSize: 38,
                  icon: const Icon(Icons.library_books),
                  color: Colors.black.withOpacity(0.8),
                  // tooltip: 'Increase volume by 10',
                  onPressed: () async {
                    final url = Uri.parse("https://elearn.dbit.in/");
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.black12, //color of border
                    width: 0.15, //width of border
                  ),
                  color: Color.fromRGBO(242, 242, 242, 1)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  iconSize: 38,
                  icon: const Icon(Icons.airplane_ticket),
                  color: Colors.black.withOpacity(0.8),
                  // tooltip: 'Increase volume by 10',
                  onPressed: () async {
                    final url = Uri.parse('https://blog.logrocket.com');
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  CarouselCard({required this.car});

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
        child: Container(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: CachedNetworkImage(
              imageUrl: car.image,
              fit: BoxFit.cover,
            ),
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
      image: 'https://wallpaperaccess.com/full/1152734.jpg',
      description:
          'As an all-electric supercar, Roadster maximizes the potential of aerodynamic engineering—with record-setting performance and efficiency.'),
  TeslaCar(
      model: 'Model S',
      image: 'https://wallpapershome.com/images/pages/pic_v/8763.jpeg',
      description:
          "Model S sets an industry standard for performance and safety. Tesla’s all-electric powertrain delivers unparalleled performance in all weather conditions."),
  TeslaCar(
      model: 'Model 3',
      image: 'https://wallpapershome.com/images/pages/ico_v/20707.jpg',
      description:
          "Model 3 comes with the option of dual motor all-wheel drive, 20” Performance Wheels and Brakes and lowered suspension for total control, in all weather conditions."),
  TeslaCar(
      model: 'Model X',
      image:
          'https://images.hdqwalls.com/download/tesla-model-x-front-4k-5x-1080x1920.jpg',
      description:
          "Tesla’s all-electric powertrain delivers Dual Motor All-Wheel Drive, adaptive air suspension and the quickest acceleration of any SUV on the road—from zero to 60 mph in 2.6 seconds."),
  TeslaCar(
      model: 'Model Y',
      image:
          'https://www.autocar.co.uk/sites/autocar.co.uk/files/images/car-reviews/first-drives/legacy/model_y_front_34_blue.jpg',
      description:
          "Tesla All-Wheel Drive has two ultra-responsive, independent electric motors that digitally control torque to the front and rear wheels—for far better handling, traction and stability."),
  TeslaCar(
      model: 'Cyber Truck',
      image: 'https://img.wallpapersafari.com/phone/750/1334/65/24/BAlZne.jpg',
      description:
          "The powerful drivetrain and low center of gravity provides extraordinary traction control and torque—enabling acceleration from 0-60 mph in as little as 2.9 seconds."),
];
