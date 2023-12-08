import 'package:flutter/material.dart';
import 'package:journal_app/screens/addjournalscreen.dart';
import 'package:journal_app/screens/viewjournalscreen.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      today = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/google.png"),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Hi, John Doe",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            // Add any other widgets you may need in this row
          ],
        ),
        const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TableCalendar(
              locale: 'en_US',
              rowHeight: 40,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, today),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                holidayTextStyle: TextStyle(color: Colors.red),
                selectedTextStyle: TextStyle(color: Colors.white),
                selectedDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              "Selected Date: ${today.toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddJournal(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "Add Journal Entry",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewJournal(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              
              child: const Text(
                "View Journal Entries",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        ],
      ),
    );
  }
}
