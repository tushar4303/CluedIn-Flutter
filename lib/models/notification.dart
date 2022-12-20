import 'dart:convert';

import 'package:collection/collection.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  static List<String>? labels;
  static List<String>? senderRoles;
  static List<Item>? items;
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

class Item {
  final int messageId;
  final String userName;
  final String userRole;
  final String messageTitle;
  final String messageLabel;
  final String userMessage;
  final String imageUrl;
  final DateTime dateOfcreation;

  Item(
      {required this.messageId,
      required this.userName,
      required this.userRole,
      required this.messageTitle,
      required this.messageLabel,
      required this.userMessage,
      required this.imageUrl,
      required this.dateOfcreation});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      messageId: map["message_id"],
      userName: map["userName"],
      userRole: map["userRole"],
      messageTitle: map["message_title"],
      messageLabel: map["message_label"],
      userMessage: map["user_message"],
      imageUrl: map["image_url"],
      dateOfcreation: DateTime.parse(map["dateOfcreation"]),
    );
  }

  toMap() => {
        "message_id": messageId,
        "userName": userName,
        "userRole": userRole,
        "message_title": messageTitle,
        "message_label": messageLabel,
        "user_message": userMessage,
        "image_url": imageUrl,
        "dateOfcreation": dateOfcreation,
      };

  @override
  String toString() {
    return 'Item(messageId: $messageId, userName: $userName, userRole: $userRole, messageTitle: $messageTitle, messageLabel: $messageLabel, userMessage: $userMessage, imageUrl: $imageUrl, dateOfcreation: $dateOfcreation)';
  }
}
