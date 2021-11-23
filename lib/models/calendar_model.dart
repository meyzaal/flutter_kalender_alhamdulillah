import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// // EventModel eventFromJson(String str) => EventModel.fromJson(json.decode(str));

// // String eventToJson(EventModel data) => json.encode(data.toJson());

// class EventModel {
//   String status;
//   String message;
//   List<Event> data;

//   EventModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory EventModel.fromJson(Map<String, dynamic> json) {
//     return EventModel(
//       status: json["status"],
//       message: json["message"],
//       data: List<Event>.from(json["data"].map((x) {
//         return Event.fromJson(x);
//       })),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "status": status,
//       "message": message,
//       "data": List<Event>.from(data.map((x) => x.toMap())),
//     };
//   }
// }

class Event {
  final String id;
  final String namaEvent, jenisEvent;
  final DateTime createdAt, waktuMulai, waktuSelesai;

  Event({
    required this.id,
    required this.createdAt,
    required this.jenisEvent,
    required this.namaEvent,
    required this.waktuMulai,
    required this.waktuSelesai,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'jenisEvent': jenisEvent,
      'namaEvent': namaEvent,
      'waktuMulai': waktuMulai,
      'waktuSelesai': waktuSelesai,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      jenisEvent: json['jenisEvent'],
      namaEvent: json['namaEvent'],
      waktuMulai: DateTime.parse(json['waktuMulai']),
      waktuSelesai: DateTime.parse(json['waktuSelesai']),
    );
  }
}

Future<List<Event>> fetchEvent() async {
  final response = await http
      .get(Uri.parse('https://618c9d27ded7fb0017bb963a.mockapi.io/events'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);

    jsonResponse.sort((a, b) {
      return a['waktuSelesai']
          .toString()
          .compareTo(b['waktuSelesai'].toString());
    });
    print(jsonResponse);
    return jsonResponse.map((data) => Event.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load Event');
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
