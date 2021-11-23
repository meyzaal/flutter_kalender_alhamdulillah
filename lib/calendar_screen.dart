import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bismillah_bisa_kek_fix_terakhir_sumpah_ampun_dah/models/calendar_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  // late final ValueNotifier<List<Event>> _selectedEvents;
  late LinkedHashMap<DateTime, List<Event>> kEvents;
  // late StreamController<Map<DateTime, List>> _streamController;
  late Future<List<Event>> futureEvent;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _current = DateTime.now();
  // DateTime _current = DateTime.now();

  // void _onVisibleDaysChanged(
  //     DateTime first, DateTime last, CalendarFormat format) {
  //   setState(() {
  //     _current = first;
  //   });
  //   print('CALLBACK: _onVisibleDaysChanged first ${first.toIso8601String()}');
  // }

  @override
  void initState() {
    super.initState();

    futureEvent = fetchEvent();

    // _selectedDay = _focusedDay;

    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // @override
  // void dispose() {
  //   _current;
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

  List<Event> _getEventsForDay(
    DateTime day,
  ) {
    // _current = day;
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onPageChanged(focusedDay) {
    _focusedDay = focusedDay;
    // print(_current);
    setState(() {
      _current = focusedDay;
    });
    // print(_current);

    // return _current;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      // print(_current);
      // _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_left),
          // iconSize: 24.0,
          onPressed: () {},
        ),
        title: Text('Kalender'),
        elevation: 0.0,
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.ellipsis_vertical),
            // iconSize: 30.0,
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
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

              // print(events);
              _groupEvents(events!);

              DateTime selectedDate = _selectedDay;
              // print(selectedDate);
              var monthFilter = events.where((element) =>
                  element.waktuSelesai.year == _current.year &&
                  element.waktuSelesai.month == _current.month);

              final _selectedEvents = kEvents[selectedDate] ?? [];
              print(_selectedEvents);

              // for (int i = 0; i < doc.length; i++) {}
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    color: Colors.blue,
                    child: TableCalendar<Event>(
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      focusedDay: _focusedDay,
                      locale: 'id_ID',
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      calendarFormat: _calendarFormat,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      availableCalendarFormats: const {
                        CalendarFormat.month: '',
                        CalendarFormat.week: ''
                      },
                      calendarStyle: CalendarStyle(
                        // Use `CalendarStyle` to customize the UI
                        outsideDaysVisible: false,

                        defaultTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                        holidayTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                        weekendTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                        todayDecoration: BoxDecoration(
                          // color: Colors.lightBlueAccent,
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        selectedTextStyle: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                        outsideTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        // formatButtonShowsNext: false,
                        formatButtonVisible: false,
                        leftChevronVisible: false,
                        rightChevronVisible: false,
                        // leftChevronIcon: Icon(
                        //   Icons.chevron_left_rounded,
                        //   color: Colors.white,
                        // ),
                        // rightChevronIcon:
                        //     Icon(Icons.chevron_right_rounded, color: Colors.white),
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300),
                        weekendStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300),
                      ),
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: _onPageChanged,
                      calendarBuilders: CalendarBuilders(
                        singleMarkerBuilder: (context, date, event) {
                          return Container(
                            height: 8.0,
                            width: 8.0,
                            margin: const EdgeInsets.all(0.5),
                            decoration: BoxDecoration(
                              // provide your own condition here
                              color: Colors.white,

                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(height: 10.0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        // color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  'Agenda Saya',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  // padding: EdgeInsets.all(5.0),
                                  // height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(100),
                                  ),
                                  child: TabBar(
                                      indicator: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      tabs: [
                                        Tab(text: 'Hari Ini'),
                                        Tab(text: 'Bulan Ini')
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TabBarView(
                                children: <Widget>[
                                  (_selectedEvents.length == 0)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/woman-thinking-while-drinking-coffee.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              'Tidak ada aktivitas hari ini',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          // physics: NeverScrollableScrollPhysics(),
                                          itemCount: _selectedEvents.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Event event =
                                                _selectedEvents[index];

                                            // return ListTile(
                                            //   title: Text(event.namaEvent),
                                            //   subtitle: Text(
                                            //       DateFormat("EEEE, dd MMMM, yyyy")
                                            //           .format(event.waktuSelesai)),
                                            // );
                                            return Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.all(5.0),
                                              margin:
                                                  EdgeInsets.only(bottom: 5.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.black26)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    height: 50.0,
                                                    width: 50.0,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.blue),
                                                    child: const Icon(
                                                      Icons.quiz_outlined,
                                                      color: Colors.white,
                                                      size: 30.0,
                                                      // color: Colors.blue,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          // "Collection",
                                                          event.jenisEvent,
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                        SizedBox(height: 5.0),
                                                        Text(
                                                          // "Quiz 1",
                                                          event.namaEvent,
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        SizedBox(height: 5.0),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.access_time,
                                                              size: 20.0,
                                                            ),
                                                            SizedBox(
                                                                width: 5.0),
                                                            Text(DateFormat
                                                                        .yMMMMd(
                                                                            'ID')
                                                                    .format(event
                                                                        .waktuSelesai) +
                                                                ' - ' +
                                                                DateFormat.Hm()
                                                                    .format(event
                                                                        .waktuSelesai)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color: Colors.lightGreen,
                                                    size: 30.0,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                  // Bulan ini
                                  (monthFilter.length == 0)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/images/woman-thinking-while-drinking-coffee.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              'Tidak ada aktivitas bulan ini',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.0),
                                            ),
                                          ],
                                        )
                                      : ListView(
                                          children: monthFilter
                                              .map(
                                                (e) => Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.all(5.0),
                                                  margin: EdgeInsets.only(
                                                      bottom: 5.0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black26)),
                                                  child: (e is Event)
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 50.0,
                                                              width: 50.0,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .blue),
                                                              child: const Icon(
                                                                Icons
                                                                    .quiz_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 30.0,
                                                                // color: Colors.blue,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 10.0),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    // "Collection",
                                                                    e.jenisEvent,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5.0),
                                                                  Text(
                                                                    // "Quiz 1",
                                                                    e.namaEvent,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5.0),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                        Icons
                                                                            .access_time,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              5.0),
                                                                      Text(DateFormat.yMMMMd('ID').format(e
                                                                              .waktuSelesai) +
                                                                          ' - ' +
                                                                          DateFormat.Hm()
                                                                              .format(e.waktuSelesai)),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 5.0),
                                                            Icon(
                                                              Icons
                                                                  .check_circle_outline_rounded,
                                                              color: Colors
                                                                  .lightGreen,
                                                              size: 30.0,
                                                            ),
                                                          ],
                                                        )
                                                      : null,
                                                ),
                                              )
                                              .toList()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )));
            }
          },
        ),
      ),
    );
  }
}
