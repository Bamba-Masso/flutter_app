import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseFirestore db =FirebaseFirestore.instance;

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
 try {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  } catch (e) {
    print('Erreur lors de la déconnexion : $e');
  }

  await _firebaseAuth.signOut();
}
// CREAT USER WUTH EMAIL-PASSWORD
Future<void> createUserWithEmailAndPassword(String username, String email,String password)async{
 final credential=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

String? currentUser= credential.user?.uid;
  db.collection("Users").doc(currentUser).set({
    "email":email,
    "uid":currentUser,
    "username":username

  });
}

// LOGIN WITH GOOGLE
Future<dynamic> signInWithGoogle() async { 
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