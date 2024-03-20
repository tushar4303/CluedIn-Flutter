// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  final List<StudentChapters>? studentChapters;
  final List<StudentClubs>? studentClubs;
  final CarouselModel? carousel;

  HomeModel(
      {required this.studentChapters,
      required this.studentClubs,
      required this.carousel});
}

class StudentChapters {
  final String title;
  final int establisedIn;
  final String desc;
  final String logo;
  final String coverPic;
  final String website;
  final List<String>? gallery;

  StudentChapters({
    required this.title,
    required this.establisedIn,
    required this.desc,
    required this.logo,
    required this.coverPic,
    required this.website,
    this.gallery,
  });

  factory StudentChapters.fromMap(Map<String, dynamic> map) {
    return StudentChapters(
      title: map["title"],
      establisedIn: map["Established_in"],
      desc: map["desc"],
      logo: map["logo"],
      coverPic: map["cover_pic"],
      website: map["website"],
      gallery: map["gallery"] != null
          ? List<String>.from(map["gallery"])
          : null, // Added gallery parsing
    );
  }

  toMap() => {
        "title": title,
        "Established_in": establisedIn,
        "desc": desc,
        "logo": logo,
        "cover_pic": coverPic,
        "website": website,
        "gallery": gallery,
      };

  @override
  String toString() {
    return 'StudentChapters(title: $title, establisedIn: $establisedIn, desc: $desc, logo: $logo, coverPic: $coverPic, website: $website, gallery: $gallery)';
  }
}

class StudentClubs {
  final String title;
  final int establisedIn;
  final String desc;
  final String logo;
  final String coverPic;
  final String website;
  final List<String>? gallery;

  StudentClubs({
    required this.title,
    required this.establisedIn,
    required this.desc,
    required this.logo,
    required this.coverPic,
    required this.website,
    this.gallery,
  });

  factory StudentClubs.fromMap(Map<String, dynamic> map) {
    return StudentClubs(
      title: map["title"],
      establisedIn: map["Established_in"],
      desc: map["desc"],
      logo: map["logo"],
      coverPic: map["cover_pic"],
      website: map["website"],
      gallery: map["gallery"] != null
          ? List<String>.from(map["gallery"])
          : null, // Added gallery parsing
    );
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "Established_in": establisedIn,
        "desc": desc,
        "logo": logo,
        "cover_pic": coverPic,
        "website": website,
        "gallery": gallery,
      };

  @override
  String toString() {
    return 'StudentClubs(title: $title, establisedIn: $establisedIn, desc: $desc, logo: $logo, coverPic: $coverPic, website: $website, gallery: $gallery)';
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
