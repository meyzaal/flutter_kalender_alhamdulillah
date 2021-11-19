import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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

void main() {
  runApp(const MyApp());
}

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(
//         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
//   ..addAll({

// });
// Map<DateTime, List<Event>> _kEventSource = {};

// final kEvents = LinkedHashMap<DateTime, List<Event>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomPageState createState() => _MyHomPageState();
}

class _MyHomPageState extends State<MyHomePage> {
  // late final ValueNotifier<List<Event>> _selectedEvents;
  late LinkedHashMap<DateTime, List<Event>> kEvents;
  // late StreamController<Map<DateTime, List>> _streamController;
  late Future<List<Event>> futureEvent;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    futureEvent = fetchEvent();
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // @override
  // void dispose() {
  //   _selectedEvents.dispose();
  //   super.dispose();
  // }

  _groupEvents(List<Event> events) {
    kEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(event.waktuSelesai.year,
          event.waktuSelesai.month, event.waktuSelesai.day, 12);
      if (kEvents[date] == null) kEvents[date] = [];
      kEvents[date]!.add(event);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: futureEvent.asStream(),
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            // (snapshot.data)!.forEach((element) {
            //   _kEventSource[DateTime(
            //     element.waktuMulai.year,
            //     element.waktuMulai.month,
            //     element.waktuMulai.day,
            //   )] = _kEventSource[DateTime(
            //             element.waktuMulai.year,
            //             element.waktuMulai.month,
            //             element.waktuMulai.day,
            //           )] !=
            //           null
            //       ? [
            //           ...?_kEventSource[DateTime(
            //             element.waktuMulai.year,
            //             element.waktuMulai.month,
            //             element.waktuMulai.day,
            //           )],
            //           element
            //         ]
            //       : [element];
            //   print(_kEventSource);
            //   print('');
            //   print(kEvents);
            // });
            if (snapshot.hasData) {
              var events = snapshot.data;
              _groupEvents(events!);
              DateTime selectedDate = _selectedDay;
              final _selectedEvents = kEvents[selectedDate] ?? [];
              // for (int i = 0; i < doc.length; i++) {}
              return Column(
                children: [
                  TableCalendar<Event>(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      // Use `CalendarStyle` to customize the UI
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      Event event = _selectedEvents[index];
                      return ListTile(
                        title: Text(event.namaEvent),
                        subtitle: Text(DateFormat("EEEE, dd MMMM, yyyy")
                            .format(event.waktuSelesai)),
                      );
                    },
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
