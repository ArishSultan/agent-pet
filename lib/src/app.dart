import 'package:agent_pet/src/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/connectivity-service.dart';


class AgentPetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      create: (context) => ConnectivityService().connectionStatusController.stream,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFFFC4346),
          fontFamily: 'SourceSansPro',
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),

          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFFFC4346)
          ),

          accentColor: Colors.white,

          textTheme: TextTheme(
            display1: TextStyle(
              color: Colors.white,
              fontSize: 16
            )
          )
        ),

        debugShowCheckedModeBanner: false,

        title: "Agent Pet",

        home: BasePage(),
      ),
    );
  }
}
