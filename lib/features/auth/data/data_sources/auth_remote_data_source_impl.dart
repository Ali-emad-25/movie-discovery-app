import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_discovery_app/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitialization;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(name.trim());

    return credential;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;

    if (user == null) return null;

    try {
      await user.reload();

      return firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await firebaseAuth.signOut();
        return null;
      }

      if (e.code == 'network-request-failed') {
        return user;
      }

      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) return;

    if (currentUser.isAnonymous) {
      await currentUser.delete();
    }

    await firebaseAuth.signOut();
  }

  @override
  Future<UserCredential> continueAsGuest() {
    return firebaseAuth.signInAnonymously();
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    _googleSignInInitialization ??= googleSignIn.initialize();
    await _googleSignInInitialization;

    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return firebaseAuth.signInWithCredential(credential);
  }
}
