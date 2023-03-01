// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDetails {
  final String fname;
  final String lname;
  final String mobno;
  final String email;
  final String branchName;
  final String profilePic;
  final String token;

  UserDetails({
    required this.fname,
    required this.lname,
    required this.mobno,
    required this.email,
    required this.branchName,
    required this.profilePic,
    required this.token,
  });

  factory UserDetails.fromMap(Map<String, dynamic> json) {
    return UserDetails(
        fname: json['user_fname'],
        lname: json['user_lname'],
        mobno: json['user_mobno'],
        email: json['user_email'],
        branchName: json['user_branch'],
        profilePic: json['user_profilePic'],
        token: json['token']);
  }

  @override
  String toString() {
    return 'UserDetails(fname: $fname, lname: $lname, mobno: $mobno, email: $email, branchName: $branchName, profilePic: $profilePic, token: $token)';
  }
}
