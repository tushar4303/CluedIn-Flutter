// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDetails {
  final int userid;
  final String fname;
  final String lname;
  final String mobno;
  final String email;
  final String branchName;
  final String profilePic;
  final int semester;
  final int bsdId;
  final String department;
  final String classValue;
  final String division;
  final String token;

  UserDetails({
    required this.userid,
    required this.fname,
    required this.lname,
    required this.mobno,
    required this.email,
    required this.branchName,
    required this.profilePic,
    required this.semester,
    required this.bsdId,
    required this.department,
    required this.classValue,
    required this.division,
    required this.token,
  });

  factory UserDetails.fromMap(Map<String, dynamic> json) {
    return UserDetails(
      userid: json['user_id'],
      fname: json['user_fname'],
      lname: json['user_lname'],
      mobno: json['user_mobno'],
      email: json['user_email'],
      branchName: json['user_branch'],
      profilePic: json['user_profilePic'],
      semester: json['semester'],
      bsdId: json['bsd_id'],
      department: json['department'],
      classValue: json['classValue'],
      division: json['division'],
      token: json['token'],
    );
  }

  @override
  String toString() {
    return 'UserDetails(userid: $userid, fname: $fname, lname: $lname, mobno: $mobno, email: $email, branchName: $branchName, profilePic: $profilePic, semester: $semester, bsdId: $bsdId, department: $department, classValue: $classValue, division: $division, token: $token)';
  }
}
