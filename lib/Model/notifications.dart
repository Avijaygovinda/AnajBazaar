// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) =>
    NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) =>
    json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    required this.status,
    required this.notifications,
  });

  int status;
  List<Notification> notifications;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        status: json["Status"],
        notifications: List<Notification>.from(
            json["Notifications"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class Notification {
  Notification({
    required this.uid,
    required this.userId,
    required this.title,
    required this.type,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int uid;
  int userId;
  String title;
  int type;
  String message;
  int status;
  String createdAt;
  DateTime updatedAt;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        uid: json["UID"],
        userId: json["userId"],
        title: json["title"],
        type: json["type"],
        message: json["message"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "UID": uid,
        "userId": userId,
        "title": title,
        "type": type,
        "message": message,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt.toIso8601String(),
      };
}
