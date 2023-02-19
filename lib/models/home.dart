// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  final List<StudentChapters>? studentChapters;
  final CarouselModel? carousel;

  HomeModel({required this.studentChapters, required this.carousel});
}

class StudentChapters {
  final String title;
  final int establisedIn;
  final String desc;
  final String logo;
  final String coverPic;
  final String website;

  StudentChapters({
    required this.title,
    required this.establisedIn,
    required this.desc,
    required this.logo,
    required this.coverPic,
    required this.website,
  });

  factory StudentChapters.fromMap(Map<String, dynamic> map) {
    return StudentChapters(
      title: map["title"],
      establisedIn: map["Established_in"],
      desc: map["desc"],
      logo: map["logo"],
      coverPic: map["cover_pic"],
      website: map["website"],
    );
  }

  toMap() => {
        "title": title,
        "Established_in": establisedIn,
        "desc": desc,
        "logo": logo,
        "cover_pic": coverPic,
        "website": website,
      };

  @override
  String toString() {
    return 'StudentChapters(title: $title, establisedIn: $establisedIn, desc: $desc, logo: $logo, coverPic: $coverPic, website: $website)';
  }
}

class CarouselModel {
  final List<CarouselSlide> slides;

  CarouselModel({
    required this.slides,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> slideJsonList = json['slides'];
    final slides =
        slideJsonList.map((json) => CarouselSlide.fromJson(json)).toList();
    return CarouselModel(
      slides: slides,
    );
  }

  Map<String, dynamic> toJson() => {
        "slides": slides.map((slide) => slide.toJson()).toList(),
      };
}

class CarouselSlide {
  final String event;
  final String photoUrl;
  final String redirectUrl;

  CarouselSlide({
    required this.event,
    required this.photoUrl,
    required this.redirectUrl,
  });

  factory CarouselSlide.fromJson(Map<String, dynamic> json) {
    return CarouselSlide(
      event: json['event_name'],
      photoUrl: json['photo_link'],
      redirectUrl: json['redirect_link'],
    );
  }

  Map<String, dynamic> toJson() => {
        "event": event,
        "photo_url": photoUrl,
        "redirect_url": redirectUrl,
      };

  @override
  String toString() {
    return 'CarouselSlide(event: $event, photoUrl: $photoUrl, redirectUrl: $redirectUrl)';
  }
}
