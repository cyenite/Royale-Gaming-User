import 'package:app_tournament/ui/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app_tournament/login/login.dart';
import 'package:app_tournament/shared/shared.dart';
import 'package:app_tournament/services/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: ErrorMessage(),
          );
        } else if (snapshot.hasData) {
          return const HomePageController();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
