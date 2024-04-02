import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({Key? key}) : super(key: key);

  @override
  _LostAndFoundPageState createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Report lost items",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        elevation: 0.3,
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const LostFoundItemCard();
              },
            )
          : ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const LostFoundItemCard();
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromRGBO(138, 138, 138, 1),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search_off), // Material icon for "Lost"
            label: 'Lost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Material icon for "Found"
            label: 'Found',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the form page
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const ReportItemForm()),
          );
        },
        label: const Text(
          'Report an item',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        icon: const Icon(
          Icons.report,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

class LostFoundItemCard extends StatelessWidget {
  const LostFoundItemCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Top row (Image and Text)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Left part (Image)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        "assets/images/placeholder.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Right part (Text)
                const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Item Name
                        Text(
                          'Laptop',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: 5), // Spacer between title and description
                        // Description
                        Text(
                          'Black colored laptop found near the library. Contact me if it\'s yours.',
                          style: TextStyle(fontSize: 14.0),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Date
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text('April 1, 24'),
                    ],
                  ),
                  // Time
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text('12:15 PM'),
                    ],
                  ),
                  // Location
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text('New Canteen'),
                    ],
                  ),
                ],
              ),
            ),

            // New row 2 with background color
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(232, 240, 249, 0.35),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: const Row(
                children: <Widget>[
                  // Circular Avatar
                  Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              "https://avatars.githubusercontent.com/u/88235295?v=4"))),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tushar Padhy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Bachelor of Engineering - IT',
                        style: TextStyle(fontSize: 14),
                      ), // Adjust as needed for branch and year
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportItemForm extends StatefulWidget {
  const ReportItemForm({Key? key}) : super(key: key);

  @override
  _ReportItemFormState createState() => _ReportItemFormState();
}

class _ReportItemFormState extends State<ReportItemForm> {
  late DateTime _selectedDateTime;
  late File? _imageFile;

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contactInfoController = TextEditingController();
  String _status = 'lost something'; // Default status

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _imageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'Enter the name of the item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Other form fields...
              TextFormField(
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                    text: DateFormat('MMMM d, yy hh:mm a')
                        .format(_selectedDateTime)),
                decoration: const InputDecoration(
                  labelText: 'Date & Time when the item was Lost/Found',
                  hintText:
                      'Enter the date and time when the item was lost/found',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter a description of the item',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter location eg: Canteen',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactInfoController,
                decoration: const InputDecoration(
                  labelText: 'Contact Info',
                  hintText: 'Enter your contact information',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                items: ['lost something', 'found something']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey), // Adding border for consistency
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Upload Image (optional):', // Label indicating the image upload field
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _getImage(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        child: const Text(
                          'Choose Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_imageFile != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.file(
                      _imageFile!,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  // You can access all the form field values using the controllers
                  // For example: _itemNameController.text, _descriptionController.text, etc.
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                clipBehavior: Clip.hardEdge,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
