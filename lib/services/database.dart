import 'package:cloud_firestore/cloud_firestore.dart';

// DatabaseService waa class-ka noo qaabilsan xiriirka Firestore Database.
// Concept: Halkan waxaan ku qabanaa dhammaan howlaha 'CRUD' (Create, Read, Update, Delete) ee xogta abka.
class DatabaseService {
  // Shaqada 'addUserData' waxay diiwaangelisaa macluumaadka isticmaalaha cusub.
  // Concept: '.doc(Id).set(userData)' waxay abuureysaa dukumenti leh ID gaar ah oo aan horay u soo samaynay.
  Future addUserData(Map<String, dynamic> userData, String Id) async {
    await FirebaseFirestore.instance.collection('users').doc(Id).set(userData);
  }

  // Shaqada 'addUserBooking' waxay keydisaa ballanta cusub ee uu isticmaalahu qabsado.
  // Concept: '.add(addBooking)' waxay u ogolaanaysaa Firebase inay si toos ah u soo saarto ID gaar ah (Auto-generated ID).
  Future addUserBooking(Map<String, dynamic> addBooking) async {
    await FirebaseFirestore.instance.collection('Booking').add(addBooking);
  }

  // Concept: 'Stream' waa xog socota oo aan kala go' lahayn.
  // 'getUserBooking' waxay noo soo celisaa ballamaha uu leeyahay hal isticmaale oo kaliya (Filtering by ID).
  Future<Stream<QuerySnapshot>> getUserBooking(String userId) async {
    return FirebaseFirestore.instance
        .collection("Booking")
        .where(
          "Id",
          isEqualTo: userId,
        ) // Halkan waxaan ku kala saaraynaa xogta (Filtering)
        .snapshots();
  }

  // Shaqadan waxay soo celisaa xogta dhammaan maamulayaasha si loo hubiyo login-ka.
  Future<QuerySnapshot> getAdminData() async {
    return await FirebaseFirestore.instance.collection("Admin").get();
  }

  // 'getAllBookings' waxaa isticmaala maamulaha si uu u arko ballamaha dadka oo dhan.
  // Concept: '.snapshots()' waxay ka dhigaysaa mid 'Live' ah oo haddii xog cusub lagu daro Firestore, UI-ga isna wuu isbeddelayaa.
  Future<Stream<QuerySnapshot>> getAllBookings() async {
    return FirebaseFirestore.instance.collection("Booking").snapshots();
  }

  // Tirtiridda macluumaadka isticmaalaha marka uu akoonkiisa tirtirto.
  Future deleteUser(String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .delete();
  }
}
