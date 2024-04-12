import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserLoggedIn(bool isLoggedIn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', isLoggedIn);
}

Future<bool> isUserLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
