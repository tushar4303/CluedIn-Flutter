// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  static List<Item>? items;
}

class Item {
  final int messageId;
  final String userName;
  final String userRole;
  final String messageTitle;
  final String messageLabel;
  final String userMessage;
  final String imageUrl;
  final DateTime dateOfCreation;

  Item(
      {required this.messageId,
      required this.userName,
      required this.userRole,
      required this.messageTitle,
      required this.messageLabel,
      required this.userMessage,
      required this.imageUrl,
      required this.dateOfCreation});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      messageId: map["message_id"],
      userName: map["userName"],
      userRole: map["userRole"],
      messageTitle: map["message_title"],
      messageLabel: map["message_label_id"],
      userMessage: map["user_message"],
      imageUrl: map["image_url"],
      dateOfCreation: DateTime.parse(map["dateOfCreation"]),
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
        "dateOfCreation": dateOfCreation,
      };

  @override
  String toString() {
    return 'Item(messageId: $messageId, userName: $userName, userRole: $userRole, messageTitle: $messageTitle, messageLabel: $messageLabel, userMessage: $userMessage, imageUrl: $imageUrl, dateOfCreation: $dateOfCreation)';
  }
}
