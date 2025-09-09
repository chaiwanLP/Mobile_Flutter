
import 'dart:convert';

List<TripGetrespone> tripGetresponeFromJson(String str) => List<TripGetrespone>.from(json.decode(str).map((x) => TripGetrespone.fromJson(x)));

String tripGetresponeToJson(List<TripGetrespone> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripGetrespone {
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripGetrespone({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripGetrespone.fromJson(Map<String, dynamic> json) => TripGetrespone(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}
