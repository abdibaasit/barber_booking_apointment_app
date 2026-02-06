import 'package:shared_preferences/shared_preferences.dart';

// sharedpreferenceHelper waa class noo fududeynaya keydinta xogta yar-yar ee gudaha talifoonka (Local Storage).
// Concept: Waxaan u isticmaalaynaa SharedPreferences si aan u keydino xogta isticmaalaha sida ID-ga iyo Magaca, si uusan mar kasta u soo gelin (Stay logged in).
class sharedpreferenceHelper {
  // Furayaasha (Keys) loo isticmaalo in xogta lagu keydiyo laguna soo saaro.
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";

  // Concept: 'SharedPreferences.getInstance()' waxay soo celisaa 'instance' loo isticmaalo akhrinta iyo qoraalka.
  // Shaqada 'saveUserId' waxay keydisaa ID-ga isticmaalaha ee talifoonka dhexdiisa.
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferenceHelper.userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      sharedpreferenceHelper.userNameKey,
      getUserName,
    );
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
      sharedpreferenceHelper.userEmailKey,
      getUserEmail,
    );
  }

  // Shaqooyinka 'get...' waxay xogta ka soo aqriyaan xusuusta talifoonka (Disk storage).
  // Concept: Haddii 'getUserId' uu soo celiyo xog, waxay la macno tahay in qofku horey u galay abka.
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedpreferenceHelper.userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedpreferenceHelper.userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedpreferenceHelper.userEmailKey);
  }

  // 'clearSharedPreferences' waxay tirtiraysaa dhammaan xogta keydsan (Logout process).
  Future<bool> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  // Shaqada lagu helayo URL-ka sawirka isticmaalaha ee gudaha ku keydsan.
  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }
}
