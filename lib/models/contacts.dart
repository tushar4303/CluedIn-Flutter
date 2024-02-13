class Contact {
  final String name;
  final String phoneNumber;
  final String? position;
  final String? email;

  Contact({
    required this.name,
    required this.phoneNumber,
    this.position,
    this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      position: json['position'],
      email: json['email'],
    );
  }
}

class ContactCategory {
  final String name;
  final List<Contact> contacts;

  ContactCategory({
    required this.name,
    required this.contacts,
  });
}
