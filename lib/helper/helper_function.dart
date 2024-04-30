import 'package:shared_preferences/shared_preferences.dart';

// HelperFunctions class for managing shared preferences
class HelperFunctions {
  // Keys for storing data in shared preferences
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // Method to save user logged-in status to shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return await sf.setBool(userLoggedInKey, isUserLoggedIn); // Saving boolean value to shared preferences
  }

  // Method to save user name to shared preferences
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return await sf.setString(userNameKey, userName); // Saving string value to shared preferences
  }

  // Method to save user email to shared preferences
  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return await sf.setString(userEmailKey, userEmail); // Saving string value to shared preferences
  }

  // Method to get user logged-in status from shared preferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return sf.getBool(userLoggedInKey); // Getting boolean value from shared preferences
  }

  // Method to get user email from shared preferences
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return sf.getString(userEmailKey); // Getting string value from shared preferences
  }

  // Method to get user name from shared preferences
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance(); // Getting instance of shared preferences
    return sf.getString(userNameKey); // Getting string value from shared preferences
  }

  // Method to save user FCM token (not implemented yet)
  static saveUserFCMToken(String? fcmToken) {
    // This method is not implemented yet
  }
}
