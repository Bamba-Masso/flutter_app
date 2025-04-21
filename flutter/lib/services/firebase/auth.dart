import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Auth{
final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;
 final GoogleSignIn _googleSignIn = GoogleSignIn();

User? get currentUser => _firebaseAuth.currentUser;
Stream<User?> get authStateChanges=> _firebaseAuth.authStateChanges();

//LOGIN WITH EMAIL-PASSWORD
Future<void>loginWithEmaiAndPassword(String email, String password )async{
  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

}

// LOGOUT
Future<void> logout() async{
  await _firebaseAuth.signOut();
}
// CREAT USER WUTH EMAIL-PASSWORD
Future<void> createUserWithEmailAndPassword(String email,String password)async{
  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
}
Future< dynamic > signInWithGoogle() async { 
    try { 
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); 
    if (googleUser == null) return null; // L'utilisateur a annulé

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication; 

    final credential = GoogleAuthProvider.credential( 
      accessToken: googleAuth.accessToken, 
      idToken: googleAuth.idToken, 
    ); 

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
    } on Exception catch (e) { 
      // TODO 
      print ( 'exception-> $e ' ); 
    } 
  }
}