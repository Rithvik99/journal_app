import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:journal_app/services/auth.dart';

class JournalEntry {
  final String title;
  final String text;

  JournalEntry(this.title, this.text);
}

class ViewJournal extends StatefulWidget {
  final String date;
  final AuthMethods auth;
  const ViewJournal({Key? key, required this.auth, required this.date})
      : super(key: key);

  @override
  State<ViewJournal> createState() => _ViewJournalState();
}

class _ViewJournalState extends State<ViewJournal> {

  Map<String, dynamic>?  userJournals = {};
  List<JournalEntry> journalEntries = [];

  // List<JournalEntry> getJournalEntries() {
  //   List<JournalEntry> entries = [];
  //   userJournals?.forEach((key, value) {
  //     // Assuming 'title' and 'text' keys exist in each journal entry
  //     entries.add(JournalEntry(value['title'], value['content']));
  //   });
  //   return entries;
  // }
  // Get journal entries from userJournals map
  List<JournalEntry> getJournalEntries(){
    List<JournalEntry> entries = [];
    userJournals?.forEach((key, value) {
      if(value['date'] == widget.date){
        entries.add(JournalEntry(value['title'], value['content']));
      }
    });
    return entries;
  }


  // fectch journals function calling function
  Future<void> fetchJournals() async {
    userJournals = await widget.auth.fetchJournals();
    journalEntries = getJournalEntries();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.date}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    return FutureBuilder<void>(
      future: fetchJournals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (journalEntries.isEmpty) {
            return Center(
              child: Text(
                "No journal entries for ${widget.date}",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: journalEntries.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journalEntries[index].title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          journalEntries[index].text,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
