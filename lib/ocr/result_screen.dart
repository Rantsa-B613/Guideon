import 'package:flutter/material.dart';
import '../ocr/main_ocr.dart';
import '../HomePage.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget {
  final String text;
  ResultScreen({Key? key, required this.text}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result scan Image',
          style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: TextEditingController(text: widget.text),
                maxLines: null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MainOcr(),
                      ),
                    ),
                    child: Text('Rescanner Image'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    ),
                    child: Text('Text Final'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
