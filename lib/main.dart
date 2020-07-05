import 'package:agent_pet/src/utils/local-data.dart';
import 'package:flutter/material.dart';
import 'package:agent_pet/src/app.dart';

void main() async {
  /// Load Local Data.
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData.loadData();

  runApp(AgentPetApp());
}
