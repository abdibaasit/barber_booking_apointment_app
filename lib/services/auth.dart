import 'package:firebase_auth/firebase_auth.dart';

// AuthMethods waa class ka masuul ah dhammaan howlaha la xiriira aqoonsiga (Authentication).
// Concept: Waxaan u isticmaalaynaa Firebase Auth si aan u maareyno soo gelidda iyo ka bixitaanka isticmaalayaasha.
class AuthMethods {
  // 'auth' waa instance-ka Firebase kaaso noo ogolaanaya inaan la xiriirno server-ka Firebase.
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Shaqadan waxay soo celisaa isticmaalaha hadda gudaha ugu jira (Logged in user).
  // Concept: Haddii 'currentUser' uu yahay null, waxay ka dhigan tahay in qofna uusan soo gelin abka.
  User? getCurrentUser() {
    return auth.currentUser;
  }

  // Shaqada 'SignOut' waxay isticmaalaha ka saaraysaa abka si ammaan ah.
  Future SignOut() async {
    await auth.signOut();
  }

  // Shaqada 'deleteuser' waxay tirtiraysaa akoonka isticmaalaha ee Firebase ka furan.
  // Concept: Tani waa talaabo ammaan ah oo muhiim u ah sirta isticmaalaha (User Privacy).
  Future deleteuser() async {
    User? user = auth.currentUser;
    //await user?.delete(); // Tirtiridda akoonka ee rasmiga ah
    await user?.delete();
  }
}
