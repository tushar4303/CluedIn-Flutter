import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EventModel {
  static List<String>? labels;
  static List<String>? senderRoles;
  static List<Events>? events;
}

class SenderRoles {
  final List senderRoles;

  SenderRoles(
    this.senderRoles,
  );

  SenderRoles copyWith({
    List? senderRoles,
  }) {
    return SenderRoles(
      senderRoles ?? this.senderRoles,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderRoles': senderRoles,
    };
  }

  factory SenderRoles.fromMap(Map<String, dynamic> map) {
    return SenderRoles(List.from(
      (map['senderRoles'] as List),
    ));
  }

  String toJson() => json.encode(toMap());

  factory SenderRoles.fromJson(String source) =>
      SenderRoles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SenderRoles(senderRoles: $senderRoles)';

  @override
  bool operator ==(covariant SenderRoles other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(other.senderRoles, senderRoles);
  }

  @override
  int get hashCode => senderRoles.hashCode;
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
  final String senderName;
  final String senderRole;
  final String senderProfilePic;
  final String eventTitle;
  final String eventLabel;
  final String eventDesc;
  final String imageUrl;
  final String attachmentUrl;
  final String registrationLink;
  final String registrationFee;
  final DateTime dateOfcreation;
  final DateTime dateOfexpiration;

  Events(
      {required this.eventId,
      required this.senderName,
      required this.senderRole,
      required this.senderProfilePic,
      required this.eventTitle,
      required this.eventLabel,
      required this.eventDesc,
      required this.imageUrl,
      required this.attachmentUrl,
      required this.registrationLink,
      required this.registrationFee,
      required this.dateOfcreation,
      required this.dateOfexpiration});

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      eventId: map["event_id"],
      senderName: map["senderName"],
      senderRole: map["senderRole"],
      senderProfilePic: map["senderProfilePic"],
      eventTitle: map["event_title"],
      eventLabel: map["event_label"],
      eventDesc: map["event_desc"],
      imageUrl: map["image_url"],
      attachmentUrl: map["attachment_url"] ?? "",
      registrationLink: map["registration_link"] ?? "",
      registrationFee: map["registration_fee"] ?? "",
      dateOfcreation: DateTime.parse(map["dateOfCreation"]),
      dateOfexpiration: DateTime.parse(map["dateOfExpiration"]),
    );
  }

  toMap() => {
        "event_id": eventId,
        "senderName": senderName,
        "senderRole": senderRole,
        "senderProfilePic": senderProfilePic,
        "event_title": eventTitle,
        "event_label": eventLabel,
        "event_desc": eventDesc,
        "image_url": imageUrl,
        "attachment_url": attachmentUrl,
        "registration_link": registrationLink,
        "registration_fee": registrationFee,
        "dateOfCreation": dateOfcreation,
        "dateOfExpiration": dateOfexpiration,
      };

  @override
  String toString() {
    return 'Events(eventId: $eventId, senderName: $senderName, senderRole: $senderRole, senderProfilePic: $senderProfilePic, eventTitle: $eventTitle, eventLabel: $eventLabel, eventDesc: $eventDesc, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, registrationLink: $registrationLink, registrationFee: $registrationFee, dateOfcreation: $dateOfcreation, dateOfexpiration: $dateOfexpiration)';
  }
}
