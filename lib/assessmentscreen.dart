import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/apifetcher.dart';
import 'package:project/homescreen.dart';

class Assessmentscreen extends StatefulWidget {
  @override
  _AssessmentscreenState createState() => _AssessmentscreenState();
}

class _AssessmentscreenState extends State<Assessmentscreen> {
  String? _selectedMood;

  final Map<String, List<String>> moodToCategories = {
    'Happy': ['happiness', 'success', 'future', 'inspiration', 'life'],
    'Sad': ['pain', 'failure', 'past'],
    'Anxious': ['anxiety', 'fear', 'choice', 'future'],
    'Grieving': ['pain', 'change', 'death'],
  };

  List<String> moods = ['Happy', 'Sad', 'Anxious', 'Grieving'];

  void _navigateToHomeScreen() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Select a Mood')),
      );
    } else {
      List<String> selectedCategories = moodToCategories[_selectedMood!] ?? [];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Homescreen(selectedCategories: selectedCategories),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(top: 100),
              child: Center(
                  child: Title(
                      color: Colors.black,
                      child: Text(
                        "What are you feeling today?",
                        style: GoogleFonts.adventPro(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      )))),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = moods[index];
                        print('Selected mood: $_selectedMood');
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedMood == moods[index]
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 41, 41, 41),
                        ),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          moods[index],
                          style: GoogleFonts.adventPro(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: _navigateToHomeScreen,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
                child: Center(
                  child: Text(
                    "Done",
                    style: GoogleFonts.adventPro(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
