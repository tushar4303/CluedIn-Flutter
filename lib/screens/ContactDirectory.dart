import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:cluedin_app/models/contacts.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cluedin_app/widgets/notificationPage/NotificationShimmer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDirectory extends StatefulWidget {
  const ContactDirectory({super.key});

  @override
  _ContactDirectoryState createState() => _ContactDirectoryState();
}

class _ContactDirectoryState extends State<ContactDirectory> {
  late Future<void> myfuture;
  late List<ContactCategory> contactCategories = [];
  final TextEditingController _searchController = TextEditingController();
  List<ContactCategory> searchResults = [];
  bool isLoading = true;

  void _copyToClipboard(String text, String dataType) {
    Clipboard.setData(ClipboardData(text: text));
    String message = dataType == 'phone'
        ? 'Copied phone number to clipboard'
        : 'Copied email to clipboard';
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<String> fetchRandomEmojiAvatar() async {
    final response = await http.get(Uri.parse(
        'https://api.dicebear.com/7.x/fun-emoji/svg?backgroundColor=b6e3f4,c0aede,d1d4f9&radius=20'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load avatar');
    }
  }

  @override
  void initState() {
    super.initState();
    myfuture = fetchAndShowShimmer();
    fetchRandomEmojiAvatar();
  }

  Future<void> fetchAndShowShimmer() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Show shimmer for at least a second
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(contactApi));
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

    // Set searchResults to contain all contacts once contactCategories is populated
    searchResults = List.from(contactCategories);

    // Move setState outside of the try-catch block
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              onChanged: searchContacts,
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
        child: isLoading
            ? buildShimmerEffect()
            : searchResults.isNotEmpty
                ? buildContactList(searchResults)
                : Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child:
                              Lottie.asset('assets/lottiefiles/noResults.json'),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No Results Found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
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
              const ListTileShimmer()
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
    // Define a constant color for the avatar background
    const avatarBackgroundColor = Colors.white;

    return GestureDetector(
      onTap: () {
        // Unfocus any text fields when the card is tapped
        FocusScope.of(context).unfocus();
      },
      child: Card(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: avatarBackgroundColor,
                child: FutureBuilder<String>(
                  future:
                      fetchRandomEmojiAvatar(), // Fetch avatar for each contact
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show shimmer effect while loading avatars
                      return SizedBox(
                        width: 64,
                        height: 64,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // Handle error gracefully
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Use the fetched SVG avatar
                      return SvgPicture.string(
                        snapshot.data!,
                        // Set default SVG content if snapshot.data is null
                        placeholderBuilder: (context) =>
                            const CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black),
                      softWrap: true,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (contact.position != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.work,
                                    size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    contact.position!,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (contact.email != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: GestureDetector(
                              onLongPress: () {
                                if (contact.email != null) {
                                  _copyToClipboard(contact.email!, 'email');
                                }
                              },
                              onTap: () {
                                if (contact.email != null) {
                                  _handleEmail(contact.email!);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.email,
                                      size: 16, color: Colors.grey[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    contact.email ?? '',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: GestureDetector(
                            onLongPress: () {
                              _copyToClipboard(contact.phoneNumber!, 'phone');
                            },
                            child: Row(
                              children: [
                                Icon(Icons.phone,
                                    size: 16, color: Colors.grey[700]),
                                const SizedBox(width: 4),
                                Text(
                                  contact.phoneNumber,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone_outlined),
                    onPressed: () async {
                      _handlePhoneCall(contact.phoneNumber);
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    onPressed: () async {
                      String whatsappUrl =
                          "https://wa.me/+91${contact.phoneNumber}";
                      _handleWhatsapp(contact.phoneNumber);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        // Assign contactCategories to searchResults when the query is empty
        searchResults = contactCategories;
      } else {
        // Filter contacts based on the search query
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
            .where((category) => category.contacts
                .isNotEmpty) // Remove categories with no matching contacts
            .toList();
      }
    });
  }

  void _launchUrl(Uri uri, String phoneNumber) async {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _handlePhoneCall(String phoneNumber) {
    final RegExp regExp = RegExp(r'\d{10}');
    final Iterable<Match> matches = regExp.allMatches(phoneNumber);
    if (matches.isNotEmpty) {
      final String phoneNo = matches.first.group(0)!;
      final Uri uri = Uri.parse("tel:$phoneNo");
      _launchUrl(uri, phoneNo);
    } else {
      // Handle other formats like (Ext: XXX)
      print("Invalid phone number format: $phoneNumber");
    }
  }

  void _handleEmail(String email) {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    _launchUrl(uri, email);
  }

  void _handleWhatsapp(String phoneNumber) {
    final RegExp regExp = RegExp(r'\d{10}');
    final Iterable<Match> matches = regExp.allMatches(phoneNumber);
    if (matches.isNotEmpty) {
      final String phoneNo = matches.first.group(0)!;
      final String whatsappUrl = "https://wa.me/+91$phoneNo";
      final Uri uri = Uri.parse(whatsappUrl);
      _launchUrl(uri, phoneNo);
    } else {
      // Handle other formats like (Ext: XXX)
      print("Invalid phone number format: $phoneNumber");
    }
  }
}
