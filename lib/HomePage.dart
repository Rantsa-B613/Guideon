import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../ocr/main_ocr.dart';
import 'package:speech_to_text/speech_to_text.dart';


import 'BardAIController.dart'; // Import BardAIController

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BardAIController controller = Get.put(BardAIController());
  TextEditingController textField = TextEditingController();

  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
      textField.text = _wordsSpoken;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff956DE5),
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 9.0),
          child: GestureDetector(
            onTap: () {
              controller.sendPrompt("Hello, what can you do for me?");
            },
            child: Image.asset(
              "assets/logo.png",
              height: 34.0,
            ),
          ),
        ),
        title: Text(
          " GUIDE - ON ",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xfff956DE5),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MainOcr(),
                  ),
                ),
                icon: const Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
        toolbarHeight: 65.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 30,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xfff956DE5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Welcome to G U I D E O N \n an artificial intelligence that guides you in your search and in your daily life.",
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center, // Centrer le texte horizontalement
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(

                      padding: EdgeInsets.only(left: 8, top: 20),
                      child: Text(
                        _speechToText.isListening
                            ? "🎤 listening..."
                            : _speechEnabled
                            ? "🎤 Tap the microphone to start listening..."
                            : " ",
                        style: TextStyle(fontSize: 10.0),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xfffF3F3F3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(e.system == "user" ? "👨‍" : "🤖",),
                              const SizedBox(width: 10),
                              Flexible(child: Text(e.message)),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff956DE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 70,
                child: Row(children: [
                  IconButton(
                    onPressed: () {
                      // Appelez une méthode pour supprimer tous les messages de l'historique
                      controller.clearHistory();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: textField,
                      decoration: const InputDecoration(
                        hintText: "You can ask what you want",
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _speechToText.isListening ? _stopListening : _startListening,
                    tooltip: 'Listen',
                    icon:Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                        () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : IconButton(
                        onPressed: () {
                          if (textField.text != "") {
                            controller.sendPrompt(textField.text);
                            textField.clear();
                          }
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                ]),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
