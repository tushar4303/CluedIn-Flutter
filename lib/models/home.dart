// ignore_for_file: public_member_api_docs, sort_constructors_first
class HomeModel {
  static List<StudentChapters>? studentChapters;
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
