import 'package:app_tournament/routes.dart';
import 'package:app_tournament/services/services.dart';
import 'package:app_tournament/shared/shared.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkModeProvider>(context);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {}
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider(
            create: (context) => FirestoreService().getUsersdata(),
            catchError: (context, error) => UserData(),
            initialData: UserData(),
            child: Builder(builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  CountryLocalizations.delegate,
                ],
                routes: appRoutes,
                themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: DesignColor.blackBackground,
                  cardColor: DesignColor.blackFront,
                  dialogTheme: const DialogTheme(backgroundColor: DesignColor.blackFront),
                  appBarTheme: const AppBarTheme(backgroundColor: DesignColor.blackFront),
                  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: DesignColor.blackFront),
                ),
                theme: ThemeData(
                  appBarTheme: const AppBarTheme(backgroundColor: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
                ),
              );
            }),
          );
        }
        return const MaterialApp(home: LoadingScreen());
      },
    );
  }
}
