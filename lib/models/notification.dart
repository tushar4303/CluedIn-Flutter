import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final String senderName;
  final String senderRole;
  final String senderProfilePic;
  late final String notificationTitle;
  final String notificationLabel;
  final String notificationMessage;
  final String imageUrl;
  final String attachmentUrl;
  final DateTime dateOfcreation;

  Notifications(
      {required this.notificationId,
      required this.senderName,
      required this.senderRole,
      required this.senderProfilePic,
      required this.notificationTitle,
      required this.notificationLabel,
      required this.notificationMessage,
      required this.imageUrl,
      required this.attachmentUrl,
      required this.dateOfcreation});

  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
      notificationId: map["notification_id"],
      senderName: map["senderName"],
      senderRole: map["senderRole"],
      senderProfilePic: map["senderProfilePic"],
      notificationTitle: map["notification_title"],
      notificationLabel: map["notification_label"],
      notificationMessage: map["notification_message"],
      imageUrl: map["image_url"] ?? "",
      attachmentUrl: map["attachment_url"] ?? "",
      dateOfcreation: DateTime.parse(map["dateOfCreation"]),
    );
  }

  toMap() => {
        "notification_id": notificationId,
        "senderName": senderName,
        "senderRole": senderRole,
        "senderProfilePic": senderProfilePic,
        "notification_title": notificationTitle,
        "notification_label": notificationLabel,
        "notification_message": notificationMessage,
        "image_url": imageUrl,
        "attachment_url": attachmentUrl,
        "dateOfCreation": dateOfcreation,
      };

  @override
  String toString() {
    return 'Notifications(notificationId: $notificationId, senderName: $senderName, senderRole: $senderRole, senderProfilePic: $senderProfilePic, notificationTitle: $notificationTitle, notificationLabel: $notificationLabel, notificationMessage: $notificationMessage, imageUrl: $imageUrl, attachmentUrl: $attachmentUrl, dateOfcreation: $dateOfcreation)';
  }
}
