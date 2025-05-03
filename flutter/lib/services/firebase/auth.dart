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
// CREAT USER WiTH EMAIL-PASSWORD
Future<void> createUserWithEmailAndPassword(String username, String email, String password) async {
  try {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String? currentUser = credential.user?.uid;
 
    if (currentUser != null) {
    //  await credential.user!.updateDisplayName(username);  
      await db.collection("Users").doc(currentUser).set({
        "email": email,
        "uid": currentUser,
        "username": username,
      });
      print("Utilisateur enregistré avec succès !");
    } else {
      print("Erreur : utilisateur non créé.");
    }
  } catch (e) {
    print("Erreur lors de la création de l'utilisateur : $e");
  }
}

// LOGIN WITH GOOGLE
Future<dynamic> signInWithGoogle() async { 
    try { 
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); 
    if (googleUser == null) return false; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication; 

    final credential = GoogleAuthProvider.credential( 
      accessToken: googleAuth.accessToken, 
      idToken: googleAuth.idToken, 
    ); 

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    
       final User? user = userCredential.user;
        if (user != null) {
  
    await FirebaseFirestore.instance.collection("Users").doc(userCredential.user?.uid).set({
    "email": userCredential.user?.email,
    "username": userCredential.user?.displayName,
    "uid": userCredential.user?.uid
  });
return true;
   
  }
   return false;
    } on Exception catch (e) { 
    
     print("Connexion échouée : $e");
    
     return false;
    } 
  }
}