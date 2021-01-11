import 'package:agent_pet/src/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:agent_pet/src/base/theme.dart';

class App extends StatelessWidget {
  static const appName = 'Agent Pet';

  static Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    return runApp(const App._());
  }

  const App._();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: AppTheme.data,

      home: HomePage(),
    );
  }
}
