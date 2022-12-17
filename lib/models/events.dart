import 'dart:convert';

class NotificationModel {
  NotificationModel({
    required this.notifications,
  });
  late final List<Notifications> notifications;

  NotificationModel noficicationResponseFromJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notifications = List.from(json['notifications'])
        .map((e) => Notifications.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notifications'] = notifications.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Notifications {
  Notifications({
    required this.notificationId,
    required this.senderName,
    required this.senderRole,
    required this.notificationTitle,
    required this.notificationLabel,
    required this.tags,
    required this.notificationDesc,
    this.notificationBanner,
    this.registrationLink,
    required this.attachments,
    required this.dateOfCreation,
    required this.dateOfExpiration,
  });
  late final int notificationId;
  late final String senderName;
  late final String senderRole;
  late final String notificationTitle;
  late final String notificationLabel;
  late final List<String> tags;
  late final String notificationDesc;
  late final String? notificationBanner;
  late final String? registrationLink;
  late final List<String> attachments;
  late final String dateOfCreation;
  late final String dateOfExpiration;

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    senderName = json['senderName'];
    senderRole = json['senderRole'];
    notificationTitle = json['notification_title'];
    notificationLabel = json['notification_label'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    notificationDesc = json['notification_desc'];
    notificationBanner = null;
    registrationLink = null;
    attachments = List.castFrom<dynamic, String>(json['attachments']);
    dateOfCreation = json['dateOfCreation'];
    dateOfExpiration = json['dateOfExpiration'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notification_id'] = notificationId;
    _data['senderName'] = senderName;
    _data['senderRole'] = senderRole;
    _data['notification_title'] = notificationTitle;
    _data['notification_label'] = notificationLabel;
    _data['tags'] = tags;
    _data['notification_desc'] = notificationDesc;
    _data['notification_banner'] = notificationBanner;
    _data['registration_link'] = registrationLink;
    _data['attachments'] = attachments;
    _data['dateOfCreation'] = dateOfCreation;
    _data['dateOfExpiration'] = dateOfExpiration;
    return _data;
  }
}
