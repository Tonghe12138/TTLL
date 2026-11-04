import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_chord_helper/paper.dart';

import 'ui/guitar_chord_app.dart';

//alt+enter
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  // );
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(GuitarChordApp());
}

