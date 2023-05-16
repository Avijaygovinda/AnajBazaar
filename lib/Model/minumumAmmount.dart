// To parse this JSON data, do
//
//     final checkMinumumAmmount = checkMinumumAmmountFromJson(jsonString);

import 'dart:convert';

CheckMinumumAmmount checkMinumumAmmountFromJson(String str) =>
    CheckMinumumAmmount.fromJson(json.decode(str));

String checkMinumumAmmountToJson(CheckMinumumAmmount data) =>
    json.encode(data.toJson());

class CheckMinumumAmmount {
  CheckMinumumAmmount({
    required this.status,
    required this.config,
  });

  int status;
  List<Config> config;

  factory CheckMinumumAmmount.fromJson(Map<String, dynamic> json) =>
      CheckMinumumAmmount(
        status: json["Status"],
        config:
            List<Config>.from(json["config"].map((x) => Config.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "config": List<dynamic>.from(config.map((x) => x.toJson())),
      };
}

class Config {
  Config({
    required this.configId,
    required this.configKey,
    required this.configValue,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int configId;
  String configKey;
  String configValue;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        configId: json["configId"],
        configKey: json["configKey"],
        configValue: json["configValue"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "configId": configId,
        "configKey": configKey,
        "configValue": configValue,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
