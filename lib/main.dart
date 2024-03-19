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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

  Color e_afinado = Colors.white;
  bool iniciado = false;

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

  // Start Button - Capturing Audio Begins
  Future<void> _startCapture() async {
    await _audioRecorder.start(listener,
        onError, // Error will appear when audio sample cannot be obtained
        sampleRate: 44100,
        bufferSize: 3000);

    setState(() {
      note = '';
      status = 'Please Sing!';
      _hasPitchDetectingStarted = true;
    });
  }

  // Stop Button - Stops Audio Capturing
  Future<void> _stopCapture() async {
    await _audioRecorder.stop();

    setState(() {
      note = '';
      status = 'Press Start!';
      _hasPitchDetectingStarted = false;
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
    // Calling Audio Samples In
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    double rms = calculateRMS(audioSample);

    // Set a threshold level for the volume
    double volumeThreshold = 0.005; // Adjust this value according to your needs

    if (rms > volumeThreshold) {
      // pitch_detector_dart library allows translating from audio sample to actual pitch
      final result = pitchDetectorDart.getPitch(audioSample);
      //print("Frequency captured: " + result.pitch.toString());

      if (result.pitch == -1.0) {
        //print("Impercepitivel");
        setState(() {});
      } else {
        //print("Amostra $i :" + result.pitch.toString());
      }
      if (result.pitch >= 70 && result.pitch <= 350) {
        setState(() {
          iniciado = true;
        });
        // Cordas do Violao afinadas emitem frequencia entre 82 e 330.
        if (result.pitch >= 72 && result.pitch <= 92) {
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da Mizona");
          setState(() {
            note = "E";
          });
          if (result.pitch >= 81.8 && result.pitch <= 82.2) {
            print("E Afinada");
            setState(() {
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch >= 70 && result.pitch < 81.8) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch >= 82.2 && result.pitch <= 92) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }

        if (result.pitch >= 92 && result.pitch <= 120) {
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da A");
          if (result.pitch >= 109 && result.pitch <= 111) {
            print("A Afinada");
            setState(() {
              note = "A";
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch >= 92 && result.pitch < 109) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch >= 112 && result.pitch <= 120) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }

        if (result.pitch >= 136 && result.pitch <= 186) {
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da D");
          if (result.pitch >= 145 && result.pitch <= 147) {
            print("A Afinada");
            setState(() {
              note = "D";
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch > 136 && result.pitch < 144) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch > 148 && result.pitch < 186) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }

        if (result.pitch >= 186 && result.pitch <= 206) {
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da G");
          if (result.pitch >= 195 && result.pitch <= 197) {
            print("G Afinada");
            setState(() {
              note = "G";
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch > 186 && result.pitch < 195) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch > 197 && result.pitch < 206) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }

        if (result.pitch >= 237 && result.pitch <= 257) {
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da B: " + result.pitch.toString());
          if (result.pitch >= 246.8 && result.pitch <= 247.2) {
            print("G Afinada");
            setState(() {
              note = "B";
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch > 237 && result.pitch < 246) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch > 248 && result.pitch < 257) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }

        if (result.pitch >= 320 && result.pitch <= 340) {
          print(result.pitch.toString());
          // Se houvir uma frequencia entre 72 e 92 eh pq esta perto da Mizona
          print("Ao redor da E");
          note = "E";
          if (result.pitch >= 329.8 && result.pitch <= 330.2) {
            print("E Afinada");
            setState(() {
              background = afinado_background;
              Cor_Texto = afinado;
              cor_button = afinado_button;
            });
          } else if (result.pitch > 320 && result.pitch < 329.8) {
            print("Acoche um pouco");
            setState(() {
              background = abaixo_background;
              Cor_Texto = abaixo;
              cor_button = abaixo_button;
            });
          } else if (result.pitch > 330.2 && result.pitch < 340) {
            print("Desafroge um pouco");
            setState(() {
              background = acima_background;
              Cor_Texto = acima;
              cor_button = acima_button;
            });
          }
        }
      }

      // When pitch has been found - it shows which note it is
      if (result.pitched) {
        // pitchupDart library allows finding note using comparison from guitar
        final handledPitchResult = pitchupDart.handlePitch(result.pitch);

        // Updating state to show the result of the note

        setState(() {
          if (handledPitchResult.note == "") {
          } else {
            note = handledPitchResult.note;
          }

          //status = '';
        });
      }
    } else {
      setState(() {
        //note = '';
      });
    }
  }

  void onError(Object e) {
    print(e);
  }

  LinearGradient background = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 24, 21, 21),
      Color.fromARGB(255, 28, 26, 26),
    ],
  );

  LinearGradient imperceptivel = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 30, 28, 28),
      Color.fromARGB(255, 27, 26, 26),
    ],
  );

  final Shader abaixo = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 1, 176, 255),
      Color.fromARGB(255, 7, 90, 255),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader afinado = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xffFFA415),
      Color(0xff137E26),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final Shader acima = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xff17EF6A),
      Color(0xffCD1C4E),
    ],
  ).createShader(Rect.fromLTWH(0.0, 50.0, 500.0, 500.0));

  Shader Cor_Texto = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 53, 17, 27),
    ],
  ).createShader(Rect.fromLTWH(0.0, 50.0, 500.0, 500.0));

  final LinearGradient abaixo_button = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 1, 176, 255),
      Color.fromARGB(255, 7, 90, 255),
    ],
  );

  LinearGradient cor_button = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color.fromARGB(255, 109, 170, 199),
      Color.fromARGB(255, 7, 90, 255),
    ],
  );

  final LinearGradient afinado_button = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xffFFA415),
      Color(0xff137E26),
    ],
  );

  final LinearGradient acima_button = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xff17EF6A),
      Color(0xffCD1C4E),
    ],
  );

  final LinearGradient afinado_background = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xff154908),
      Color(0xff000000),
    ],
  );

  final LinearGradient abaixo_background = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 8, 48, 73),
      Color.fromARGB(255, 16, 18, 53),
    ],
  );

  final LinearGradient acima_background = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xff490808),
      Color(0xff1E0909),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: background,
          ), // Background Gradiation Widget Add
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Visibility(
                    visible: _hasPitchDetectingStarted,
                    child: Container(
                      child: Text(
                        "Iniciado",
                        style: TextStyle(
                          foreground: Paint()..shader = Cor_Texto,
                          fontSize: 12,
                        ),
                        // This was added to show notes in the middle.
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _hasPitchDetectingStarted,
                    child: Container(
                      child: Text(
                        note,
                        style: TextStyle(
                          foreground: Paint()..shader = Cor_Texto,
                          fontSize: 180,
                        ),
                        // This was added to show notes in the middle.
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_hasPitchDetectingStarted,
                    child: Center(
                      child: Container(
                        child: ElevatedButton(
                          child: Text(
                            "Afinar",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: _startCapture,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _hasPitchDetectingStarted && iniciado,
                    child: Container(
                      width: 307,
                      height: 32,
                      decoration: BoxDecoration(
                          gradient: cor_button,
                          borderRadius:
                              BorderRadius.all(Radius.circular(16)) //Border.all
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
