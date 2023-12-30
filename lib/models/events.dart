import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EventModel {
  static List<String>? labels;
  static List<String>? organizers;
  static List<Events>? events;
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

class Events {
  final int eventId;
  final String sender_fname;
  final String sender_lname;
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
  final DateTime dateOfcreation;
  final DateTime? dateOfexpiration;

  Events(
      {required this.eventId,
      required this.sender_fname,
      required this.sender_lname,
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
      required this.dateOfcreation,
      this.dateOfexpiration});

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      eventId: map["event_id"],
      sender_fname: map["sender_fname"] ?? "",
      sender_lname: map["sender_lname"] ?? "",
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
      dateOfcreation: DateTime.parse(map["dateOfCreation"] ?? ""),
      dateOfexpiration: DateTime.tryParse(map["dateOfExpiration"] ?? ""),
    );
  }

  toMap() => {
        "event_id": eventId,
        "sender_fname": sender_fname,
        "sender_lname": sender_lname,
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
        "dateOfCreation": dateOfcreation,
        "dateOfExpiration": dateOfexpiration,
      };

  @override
  String toString() {
    return 'Events(eventId: $eventId, sender_fname: $sender_fname, sender_lname: $sender_lname, senderRole: $senderRole, organizedBy: $organizedBy, senderProfilePic: $senderProfilePic, eventTitle: $eventTitle, eventLabel: $eventLabel, eventDesc: $eventDesc, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, registrationLink: $registrationLink, registrationFee: $registrationFee, dateOfcreation: $dateOfcreation, dateOfexpiration: $dateOfexpiration)';
  }
}
