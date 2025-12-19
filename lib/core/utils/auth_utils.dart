// lib/utils/auth_utils.dart (Create this new file)
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  // Accessing SharedPreferences is an asynchronous operation
  final prefs = await SharedPreferences.getInstance();
  // We use final id = prefs.getInt('user_id'); as per your request
  final userId = prefs.getInt('user_id');

  // If userId is NOT null, the user is considered logged in.
  return userId != null;
}