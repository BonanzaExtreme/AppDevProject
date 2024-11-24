import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/apifetcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  _NotificationscreenState createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> categories = [
    'random',
    'anxiety',
    'change',
    'choice',
    'confidence',
    'courage',
    'death',
    'dreams',
    'excellence',
    'failure',
    'fairness',
    'fear',
    'forgiveness',
    'freedom',
    'future',
    'happiness',
    'inspiration',
    'kindness',
    'leadership',
    'life',
    'living',
    'love',
    'pain',
    'past',
    'success',
    'time',
    'today',
    'truth',
    'work',
  ];
  int _selectedCategoryIndex = 0;
  int _notificationCount = 1;
  int _frequencyIndex = 0;
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    print("Time zones initialized");
    _intializeNotification();
    _createNotificationChannel();
  }

  void _intializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channelId',
      'channelName',
      description: 'This is notification.',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _fetchQuotes() async {
    try {
      final category = categories[_selectedCategoryIndex];
      final apiFetcher = Apifetcher();
      final quotes = await apiFetcher.fetchQuotes(keyword: category);

      if (quotes.isEmpty) {
        print("No quotes available for the selected category.");
        return;
      }

      for (int i = 0; i < _notificationCount; i++) {
        DateTime startDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _startTime.hour,
          _startTime.minute,
        );
        tz.TZDateTime tzStartTime =
            tz.TZDateTime.from(startDateTime, tz.getLocation('Asia/Singapore'));

        DateTime endDateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _endTime.hour,
          _endTime.minute,
        );
        tz.TZDateTime tzEndTime =
            tz.TZDateTime.from(endDateTime, tz.getLocation('Asia/Singapore'));

        String quote =
            quotes[i % quotes.length]['quote'] ?? "No quote available";
        String author = quotes[i % quotes.length]['author'] ?? "Unknown";

        String formattedStartTime = tzStartTime.toLocal().toString();
        String formattedEndTime = tzEndTime.toLocal().toString();

        print(
            "Fetched Quote: '$quote' by $author\nScheduled Start Time: $formattedStartTime\nScheduled End Time: $formattedEndTime");

        _scheduleNotification(i, quote, author, tzStartTime);
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  //Scheduling of notification
  void _scheduleNotification(
      int id, String title, String body, tz.TZDateTime tzdatetime) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'This is notiifcation.',
            importance: Importance.max,
            priority: Priority.high);

    const NotificationDetails platformdetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzdatetime,
      platformdetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "Notifications",
                  style: GoogleFonts.adventPro(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                _categorySelector(),
                SizedBox(height: 20),
                _NotificationCountSelector(),
                SizedBox(height: 20),
                _FrequencySelector(),
                SizedBox(height: 20),
                _TimePicker(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _fetchQuotes();
                  },
                  child: Text("Save Settings"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Widget _SettingBox({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.adventPro(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _categorySelector() {
    return _SettingBox(
        title: 'Types of quotes',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryIndex =
                        (_selectedCategoryIndex - 1 + categories.length) %
                            categories.length;
                    _fetchQuotes();
                  });
                },
                icon: Icon(Icons.arrow_left)),
            Text(categories[_selectedCategoryIndex],
                style: GoogleFonts.adventPro(
                  color: Colors.black,
                  fontSize: 22,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    _selectedCategoryIndex =
                        (_selectedCategoryIndex + 1 - categories.length) %
                            categories.length;
                    _fetchQuotes();
                  });
                },
                icon: Icon(Icons.arrow_right))
          ],
        ));
  }

  Widget _NotificationCountSelector() {
    return _SettingBox(
        title: 'How many notifications',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (_notificationCount > 1) _notificationCount--;
                  });
                },
                icon: Icon(Icons.arrow_left)),
            Text("$_notificationCount",
                style: GoogleFonts.adventPro(
                  color: Colors.black,
                  fontSize: 22,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    if (_notificationCount < 10) _notificationCount++;
                  });
                },
                icon: Icon(Icons.arrow_right)),
          ],
        ));
  }

  Widget _FrequencySelector() {
    return _SettingBox(
        title: 'Frequency of Notifications',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _frequencyIndex == 0
                  ? "Once a day"
                  : _frequencyIndex == 1
                      ? "Twice a day"
                      : "Every 3 hours",
              style: GoogleFonts.adventPro(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            Slider(
              value: _frequencyIndex.toDouble(),
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) {
                setState(() {
                  _frequencyIndex = value.toInt();
                });
              },
            )
          ],
        ));
  }

  Widget _TimePicker() {
    return _SettingBox(
        title: 'Duration of Notification',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Timebutton("Start time", _startTime, (selectedTime) {
              setState(() {
                _startTime = selectedTime;
              });
            }),
            _Timebutton("End Time", _endTime, (selectedTime) {
              setState(() {
                _endTime = selectedTime;
              });
            })
          ],
        ));
  }

  Widget _Timebutton(String title, TimeOfDay selectedTime,
      Function(TimeOfDay) onTimeSelected) {
    return Column(
      children: [
        Text(title),
        TextButton(
            onPressed: () async {
              TimeOfDay? newTime = await showTimePicker(
                  context: context, initialTime: selectedTime);
              if (newTime != null) {
                onTimeSelected(newTime);
              }
            },
            child: Text(selectedTime.format(context)))
      ],
    );
  }
}
