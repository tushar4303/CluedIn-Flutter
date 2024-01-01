import 'dart:convert';
import 'dart:math';
import 'package:cluedin_app/widgets/notificationPage/NotificationShimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

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

class ContactDirectory extends StatefulWidget {
  const ContactDirectory({Key? key}) : super(key: key);

  @override
  _ContactDirectoryState createState() => _ContactDirectoryState();
}

class _ContactDirectoryState extends State<ContactDirectory> {
  late List<ContactCategory> contactCategories;
  final TextEditingController _searchController = TextEditingController();
  List<ContactCategory> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndShowShimmer();
  }

  Future<void> fetchAndShowShimmer() async {
    await Future.delayed(
        Duration(seconds: 1)); // Show shimmer for at least a second
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('http://cluedin.creast.in:5000/contactDirectory'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        contactCategories = data
            .map((category) => ContactCategory(
                  name: category['name'],
                  contacts: (category['contacts'] as List<dynamic>)
                      .map((contact) => Contact.fromJson(contact))
                      .toList(),
                ))
            .toList();
      } else {
        print('Error: ${response.statusCode}');
      }
    } on Exception catch (error) {
      print('Error: $error');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        elevation: 0.3,
        scrolledUnderElevation: 0.6,
        title: const Text(
          "Contacts",
          textScaleFactor: 1.3,
        ),
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchContacts(value);
              },
              decoration: InputDecoration(
                hintText: "Search contacts...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchContacts("");
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? buildShimmerEffect()
              : _searchController.text.isEmpty
                  ? buildContactList(contactCategories)
                  : buildSearchResults(searchResults),
        ),
      ),
    );
  }

  Widget buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ListTileShimmer()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactList(List<ContactCategory> categories) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    category.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: category.contacts.length,
                itemBuilder: (context, contactIndex) {
                  final contact = category.contacts[contactIndex];
                  return buildContactListItem(contact);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSearchResults(List<ContactCategory> results) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, categoryIndex) {
          final category = results[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: category.contacts.length,
                itemBuilder: (context, contactIndex) {
                  final contact = category.contacts[contactIndex];
                  return buildContactListItem(contact);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildContactListItem(Contact contact) {
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    return Card(
      color: Colors.white,
      child: ListTile(
        isThreeLine: true,
        visualDensity: VisualDensity(horizontal: -4, vertical: 0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
        leading: CircleAvatar(
          radius: 36,
          backgroundColor: randomColor,
          child: Text(
            contact.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          contact.name,
          style: TextStyle(fontWeight: FontWeight.w500),
          softWrap: true,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.position != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.work, size: 16, color: Colors.grey[700]),
                    SizedBox(width: 4),
                    Text(
                      "${contact.position!}",
                      softWrap: true,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            if (contact.email != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.email, size: 16, color: Colors.grey[700]),
                    SizedBox(width: 4),
                    Text(
                      "${contact.email!}",
                      softWrap: true,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[700]),
                  SizedBox(width: 4),
                  Text(
                    "${contact.phoneNumber}",
                    softWrap: true,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone_outlined),
          onPressed: () {
            launchUrl(Uri.parse("tel:${contact.phoneNumber}"));
          },
        ),
        onTap: () {
          // Add additional action when the contact is tapped
        },
      ),
    );
  }

  void searchContacts(String query) {
    setState(() {
      searchResults = contactCategories
          .map((category) => ContactCategory(
                name: category.name,
                contacts: category.contacts
                    .where((contact) =>
                        contact.name
                            .toLowerCase()
                            .contains(query.toLowerCase()) ||
                        (contact.position != null &&
                            contact.position!
                                .toLowerCase()
                                .contains(query.toLowerCase())) ||
                        (contact.email != null &&
                            contact.email!
                                .toLowerCase()
                                .contains(query.toLowerCase())) ||
                        contact.phoneNumber.contains(query))
                    .toList(),
              ))
          .toList();
    });
  }

  void launchUrl(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $uri';
    }
  }
}
