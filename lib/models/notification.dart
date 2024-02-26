import 'dart:convert';
import 'package:collection/collection.dart';

class NotificationModel {
  static List<String>? labels;
  static List<String>? senderRoles;
  static List<Notifications>? notifications;
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

class Notifications {
  final int notificationId;
  final String sender_fname;
  final String sender_lname;
  final String senderRole;
  final String senderProfilePic;
  final String notificationTitle;
  final String notificationLabel;
  final String nm_registration_url;
  final String notificationMessage;
  final String imageUrl;
  final String attachmentUrl;
  final DateTime dateOfcreation;
  final int isRead;

  Notifications(
      {required this.notificationId,
      required this.sender_fname,
      required this.sender_lname,
      required this.senderRole,
      required this.senderProfilePic,
      required this.notificationTitle,
      required this.notificationLabel,
      required this.nm_registration_url,
      required this.notificationMessage,
      required this.imageUrl,
      required this.attachmentUrl,
      required this.dateOfcreation,
      required this.isRead});

  factory Notifications.fromMap(Map<String, dynamic> map) {
    print("Date of Creation String: ${map["nm_registration_url"]}");
    return Notifications(
        notificationId: map["notification_id"],
        sender_fname: map["sender_fname"],
        sender_lname: map["sender_lname"],
        senderRole: map["senderRole"],
        senderProfilePic: map["senderProfilePic"],
        notificationTitle: map["notification_title"],
        notificationLabel: map["notification_label"],
        notificationMessage: map["notification_message"],
        imageUrl: map["image_url"] ?? "",
        attachmentUrl: map["attachment_url"] ?? "",
        nm_registration_url: map["nm_registration_url"] ?? "",
        dateOfcreation: DateTime.parse(map["dateOfCreation"]),
        isRead: map["isRead"]);
  }

  toMap() => {
        "notification_id": notificationId,
        "sender_fname": sender_fname,
        "sender_lname": sender_lname,
        "senderRole": senderRole,
        "senderProfilePic": senderProfilePic,
        "notification_title": notificationTitle,
        "notification_label": notificationLabel,
        "notification_message": notificationMessage,
        "image_url": imageUrl,
        "attachment_url": attachmentUrl,
        "nm_registration_url": nm_registration_url,
        "dateOfCreation": dateOfcreation,
        "isRead": isRead
      };

  @override
  String toString() {
    return 'Notifications(notificationId: $notificationId, sender_fname: $sender_fname, sender_lname: $sender_lname, senderRole: $senderRole, senderProfilePic: $senderProfilePic, notificationTitle: $notificationTitle, notificationLabel: $notificationLabel, notificationMessage: $notificationMessage, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, nm_registration_url: $nm_registration_url dateOfcreation: $dateOfcreation, isRead: $isRead)';
  }
}
