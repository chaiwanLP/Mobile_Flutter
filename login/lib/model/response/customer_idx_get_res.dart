// To parse this JSON data, do
//
//     final customeridxGetrespone = customeridxGetresponeFromJson(jsonString);

import 'dart:convert';

CustomeridxGetrespone customeridxGetresponeFromJson(String str) => CustomeridxGetrespone.fromJson(json.decode(str));

String customeridxGetresponeToJson(CustomeridxGetrespone data) => json.encode(data.toJson());

class CustomeridxGetrespone {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CustomeridxGetrespone({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CustomeridxGetrespone.fromJson(Map<String, dynamic> json) => CustomeridxGetrespone(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
