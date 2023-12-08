import 'package:flutter/material.dart';
import 'package:journal_app/services/auth.dart';

class AddJournal extends StatefulWidget {
  final AuthMethods auth;
  final String date;
  const AddJournal({Key? key, required this.date, required this.auth}) : super(key: key);

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  late TextEditingController titleController;
  late TextEditingController entryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    entryController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose the controllers to free up resources
    titleController.dispose();
    entryController.dispose();
    super.dispose();
  }

  void addEntry() async {
    // Access the entered values using the controllers
    String title = titleController.text;
    String entry = entryController.text;

    await widget.auth.addJournalEntry(title, entry, widget.date);
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Journal Entry to ${widget.date}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter title...',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Journal Entry',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: TextFormField(
                  controller: entryController,
                  maxLines: null, // Allows for multiline input
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your journal entry...',
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addEntry();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Save Entry', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}