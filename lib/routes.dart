import 'package:app_tournament/about/about.dart';
import 'package:app_tournament/profile/profile.dart';
import 'package:app_tournament/login/login.dart';
import 'package:app_tournament/games/new_games.dart';
import 'package:app_tournament/home/home.dart';
import 'package:app_tournament/ui/home/home_page.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/HomePageController': (context) => const HomePageController(),
  '/topics': (context) => const NewGamesScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
