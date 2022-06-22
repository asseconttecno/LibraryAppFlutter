import 'package:flutter/material.dart';

import 'package:assecontservices/assecontservices.dart';

import 'routas.dart';

void main() {
  Assecontservices.init(
      config: ConfiguracoesModel(
          apiAsseweb: '',
          apiHolerite: '',
          apiHoleriteEmail: '',
          apiAsseponto: '',
          apiEspelho: '',
          androidAppId: '',
          iosAppId: '',
          iosAppIdNum: '',
          nomeApp: VersaoApp.PontoApp
      ),
      rotas: RouteGenerator.generateRoute
  );
}

class MyCustomApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyCustomApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asseponto Mobile',
      debugShowCheckedModeBanner: false,
      theme: context.watch<Config>().darkTemas ?
      ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: ThemeData.dark().primaryColor,
          titleTextStyle: TextStyle(color: Config.corPri,),
          toolbarTextStyle: TextStyle(color: Config.corPri,fontSize: 18),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ) : ThemeData.light().copyWith(
        primaryColor: Config.corPribar ,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Config.corPri,),
          toolbarTextStyle: TextStyle(color: Config.corPri,fontSize: 18),
          elevation: 0,
          color: Config.corPribar,
        ),
      ),
      supportedLocales: [const Locale('pt', 'BR')],
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}