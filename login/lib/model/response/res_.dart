// To parse this JSON data, do
//
//     final registerRq = registerRqFromJson(jsonString);

import 'dart:convert';

RegisterRes resFromJson(String str) => RegisterRes.fromJson(json.decode(str));

String registerRqToJson(RegisterRes data) => json.encode(data.toJson());

class RegisterRes {
    String message;
    int id;

    RegisterRes({
        required this.message,
        required this.id,
    });

    factory RegisterRes.fromJson(Map<String, dynamic> json) => RegisterRes(
        message: json["message"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
    };
}
