import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuner Simple',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Texto do botão Branco
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, // Cor do texto do AppBar
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int i = 0;
  bool _hasPitchDetectingStarted = false;
  bool iniciado = false;
  Color backgroundColor = Colors.black;
  Color textColor = Colors.white;

  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 3000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  var note = '';
  var status = 'Press the Image!';

  getPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      print('Approved');
    } else if (status.isDenied) {
      print('Refused');
      Permission.microphone.request();
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);

    setState(() {
      note = '';
      status = 'Please Sing!';
      _hasPitchDetectingStarted = true;
    });
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = '';
      status = 'Press Start!';
      _hasPitchDetectingStarted = false;
      backgroundColor = Colors.black;
      textColor = Colors.white;
    });
  }

  double calculateRMS(List<double> samples) {
    double sumOfSquares = 0.0;
    for (int i = 0; i < samples.length; i++) {
      sumOfSquares += samples[i] * samples[i];
    }
    double rms = sqrt(sumOfSquares / samples.length);
    return rms;
  }

  void listener(dynamic obj) {
    setState(() {
      i += 1;
    });

    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    double rms = calculateRMS(audioSample);

    double volumeThreshold = 0.005; // Ajuste conforme necessário

    if (rms > volumeThreshold) {
      final result = pitchDetectorDart.getPitch(audioSample);

      if (result.pitch == -1.0) {
        setState(() {});
      } else {
        if (result.pitch >= 70 && result.pitch <= 350) {
          setState(() {
            iniciado = true;
          });

          Color correctColor = Colors.green;
          Color incorrectColor = Colors.red;

          if (result.pitch >= 72 && result.pitch <= 92) {
            setState(() {
              note = "E";
              if (result.pitch >= 81.8 && result.pitch <= 82.2) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch >= 70 && result.pitch < 81.8) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch >= 82.2 && result.pitch <= 92) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          } else if (result.pitch >= 92 && result.pitch <= 120) {
            setState(() {
              note = "A";
              if (result.pitch >= 109 && result.pitch <= 111) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch >= 92 && result.pitch < 109) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch >= 112 && result.pitch <= 120) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          } else if (result.pitch >= 136 && result.pitch <= 186) {
            setState(() {
              note = "D";
              if (result.pitch >= 145 && result.pitch <= 147) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch > 136 && result.pitch < 144) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch > 148 && result.pitch < 186) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          } else if (result.pitch >= 186 && result.pitch <= 206) {
            setState(() {
              note = "G";
              if (result.pitch >= 195 && result.pitch <= 197) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch > 186 && result.pitch < 195) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch > 197 && result.pitch < 206) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          } else if (result.pitch >= 237 && result.pitch <= 257) {
            setState(() {
              note = "B";
              if (result.pitch >= 246.8 && result.pitch <= 247.2) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch > 237 && result.pitch < 246) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch > 248 && result.pitch < 257) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          } else if (result.pitch >= 320 && result.pitch <= 340) {
            setState(() {
              note = "E";
              if (result.pitch >= 329.8 && result.pitch <= 330.2) {
                backgroundColor = correctColor;
                textColor = Colors.black;
              } else if (result.pitch > 320 && result.pitch < 329.8) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              } else if (result.pitch > 330.2 && result.pitch < 340) {
                backgroundColor = incorrectColor;
                textColor = Colors.white;
              }
            });
          }
        }

        final handledPitchResult = pitchupDart.handlePitch(result.pitch);

        setState(() {
          if (handledPitchResult.note == "") {
          } else {
            note = handledPitchResult.note;
          }
        });
      }
    } else {
      setState(() {});
    }
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _hasPitchDetectingStarted,
                child: Text(
                  note,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 180,
                  ),
                ),
              ),
              Visibility(
                visible: !_hasPitchDetectingStarted,
                child: ElevatedButton(
                  child: Text(
                    "Afinar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _startCapture,
                ),
              ),
              Visibility(
                visible: _hasPitchDetectingStarted && iniciado,
                child: ElevatedButton(
                  child: Text(
                    "Parar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _stopCapture,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
