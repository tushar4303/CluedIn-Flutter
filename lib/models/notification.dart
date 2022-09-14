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
  final String dateOfExpiration;

  Item(
      {required this.messageId,
      required this.userName,
      required this.userRole,
      required this.messageTitle,
      required this.messageLabel,
      required this.userMessage,
      required this.imageUrl,
      required this.dateOfExpiration});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      messageId: map["messageId"],
      userName: map["userName"],
      userRole: map["userRole"],
      messageTitle: map["messageTitle"],
      messageLabel: map["messageLabel"],
      userMessage: map["userMessage"],
      imageUrl: map["imageUrl"],
      dateOfExpiration: map["dateOfExpiration"],
    );
  }

  toMap() => {
        "messageId": messageId,
        "userName": userName,
        "userRole": userRole,
        "messageTitle": messageTitle,
        "messageLabel": messageLabel,
        "userMessage": userMessage,
        "imageUrl": imageUrl,
        "ddateOfExpiration": dateOfExpiration,
      };

  @override
  String toString() {
    return 'Item(messageId: $messageId, userName: $userName, userRole: $userRole, messageTitle: $messageTitle, messageLabel: $messageLabel, userMessage: $userMessage, imageUrl: $imageUrl, dateOfExpiration: $dateOfExpiration)';
  }
}
