// To parse this JSON data, do
//
//     final registerRq = registerRqFromJson(jsonString);

import 'dart:convert';

RegisterRq registerRqFromJson(String str) => RegisterRq.fromJson(json.decode(str));

String registerRqToJson(RegisterRq data) => json.encode(data.toJson());

class RegisterRq {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    RegisterRq({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory RegisterRq.fromJson(Map<String, dynamic> json) => RegisterRq(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
