import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EventModel {
  static List<String>? labels;
  static List<String>? organizers;
  static List<Events>? events;
  static List<AcademicEvent>? calendarEvents; // New list for academic events
}

class Organizers {
  final List organizers;

  Organizers(
    this.organizers,
  );

  Organizers copyWith({
    List? senderRoles,
  }) {
    return Organizers(
      senderRoles ?? organizers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'organizers': organizers,
    };
  }

  factory Organizers.fromMap(Map<String, dynamic> map) {
    return Organizers(List.from(
      (map['organizers'] as List),
    ));
  }

  String toJson() => json.encode(toMap());

  factory Organizers.fromJson(String source) =>
      Organizers.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SenderRoles(senderRoles: $organizers)';

  @override
  bool operator ==(covariant Organizers other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.organizers, organizers);
  }

  @override
  int get hashCode => organizers.hashCode;
}

class Labels {
  final List labels;

  Labels(
    this.labels,
  );

  Labels copyWith({
    List? labels,
  }) {
    return Labels(
      labels ?? this.labels,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'labels': labels,
    };
  }

  factory Labels.fromMap(Map<String, dynamic> map) {
    return Labels(List.from(
      (map['labels'] as List),
    ));
  }

  String toJson() => json.encode(toMap());

  factory Labels.fromJson(String source) =>
      Labels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Labels(labels: $labels)';

  @override
  bool operator ==(covariant Labels other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.labels, labels);
  }

  @override
  int get hashCode => labels.hashCode;
}

class AcademicEvent {
  final int aceId;
  final String eventName;
  final String eventCategory;
  final DateTime dateOfEvent;
  final DateTime dateOfExpiry;

  AcademicEvent({
    required this.aceId,
    required this.eventName,
    required this.eventCategory,
    required DateTime dateOfEvent,
    required DateTime dateOfExpiry,
  })  : dateOfEvent = dateOfEvent,
        dateOfExpiry = dateOfExpiry.isAfter(dateOfEvent)
            ? dateOfExpiry
            : dateOfEvent.add(const Duration(
                days:
                    1)); // Set dateOfExpiry to be at least one day after dateOfEvent

  factory AcademicEvent.fromMap(Map<String, dynamic> map) {
    return AcademicEvent(
      aceId: map['ace_id'],
      eventName: map['ac_eventName'],
      eventCategory: map['event_category'],
      dateOfEvent: DateTime.parse(map['dateOfEvent']),
      dateOfExpiry: DateTime.parse(map['dateOfExpiry']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ace_id': aceId,
      'ac_eventName': eventName,
      'event_category': eventCategory,
      'dateOfEvent': dateOfEvent.toIso8601String(),
      'dateOfExpiry': dateOfExpiry.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory AcademicEvent.fromJson(String source) =>
      AcademicEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AcademicEvent(aceId: $aceId, eventName: $eventName, eventCategory: $eventCategory, dateOfEvent: $dateOfEvent, dateOfExpiry: $dateOfExpiry)';
  }
}

class Events {
  final int eventId;
  final String senderFname;
  final String senderLname;
  final String senderRole;
  final String organizedBy;
  final String senderProfilePic;
  final String eventTitle;
  final String eventLabel;
  final String eventDesc;
  final String imageUrl;
  final String attachmentUrl;
  final String registrationLink;
  final String registrationFee;
  final DateTime dateOfCreation;
  final DateTime dateOfEvent;
  final DateTime? dateOfExpiration;

  Events({
    required this.eventId,
    required this.senderFname,
    required this.senderLname,
    required this.senderRole,
    required this.organizedBy,
    required this.senderProfilePic,
    required this.eventTitle,
    required this.eventLabel,
    required this.eventDesc,
    required this.imageUrl,
    required this.attachmentUrl,
    required this.registrationLink,
    required this.registrationFee,
    required this.dateOfCreation,
    required this.dateOfEvent,
    this.dateOfExpiration,
  });

  factory Events.fromMap(Map<String, dynamic> map) {
    print("Date of Creation String: ${map["dateOfCreation"]}");
    print("Date of Event String: ${map["dateOfEvent"]}");
    print("Date of Expiration String: ${map["dateOfExpiration"]}");

    return Events(
      eventId: map["event_id"],
      senderFname: map["sender_fname"] ?? "",
      senderLname: map["sender_lname"] ?? "",
      senderRole: map["senderRole"] ?? "",
      organizedBy: map["organizedBy"] ?? "",
      senderProfilePic: map["senderProfilePic"] ?? "",
      eventTitle: map["event_title"] ?? "",
      eventLabel: map["event_label"] ?? "",
      eventDesc: map["event_desc"] ?? "",
      imageUrl: map["event_image_url"] ?? "",
      attachmentUrl: map["event_attachment_url"] ?? "",
      registrationLink: map["registration_link"] ?? "",
      registrationFee: map["registration_fee"] ?? "",
      dateOfCreation: DateTime.parse(map["dateOfCreation"]),
      dateOfEvent: map["dateOfEvent"].isNotEmpty
          ? DateTime.parse(map["dateOfEvent"])
          : DateTime.parse(map["dateOfCreation"]),
      dateOfExpiration: map["dateOfExpiration"] != null
          ? DateTime.parse(map["dateOfExpiration"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "event_id": eventId,
      "sender_fname": senderFname,
      "sender_lname": senderLname,
      "senderRole": senderRole,
      "organizedBy": organizedBy,
      "senderProfilePic": senderProfilePic,
      "event_title": eventTitle,
      "event_label": eventLabel,
      "event_desc": eventDesc,
      "event_image_url": imageUrl,
      "event_attachment_url": attachmentUrl,
      "registration_link": registrationLink,
      "registration_fee": registrationFee,
      "dateOfCreation": dateOfCreation.toIso8601String(),
      "dateOfEvent": dateOfEvent.toIso8601String(),
      "dateOfExpiration": dateOfExpiration?.toIso8601String(),
    };
  }

  factory Events.fromJson(String source) => Events.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Events(eventId: $eventId, senderFname: $senderFname, senderLname: $senderLname, senderRole: $senderRole, organizedBy: $organizedBy, senderProfilePic: $senderProfilePic, eventTitle: $eventTitle, eventLabel: $eventLabel, eventDesc: $eventDesc, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, registrationLink: $registrationLink, registrationFee: $registrationFee, dateOfCreation: $dateOfCreation, dateOfEvent: $dateOfEvent, dateOfExpiration: $dateOfExpiration)';
  }
}
