import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthenticationEvent {}

class AuthenticationStarted extends AuthenticationEvent {}

class GoogleSignInRequested extends AuthenticationEvent {}

class AnonymousSignInRequested extends AuthenticationEvent {}

class SignOutRequested extends AuthenticationEvent {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final User user;
  AuthenticationUserChanged(this.user);
}

enum AuthenticationState { unauthenticated, authenticating, authenticated }

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationBloc(this._firebaseAuth, this._googleSignIn)
      : super(AuthenticationState.unauthenticated) {
    on<AuthenticationStarted>((event, emit) async {
      emit(AuthenticationState.authenticating); // Show a loading state

      // Get the current user from Firebase
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        emit(AuthenticationState.authenticated);
      } else {
        emit(AuthenticationState.unauthenticated);
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthenticationState.authenticating);
      try {
        await _googleSignIn.signOut();
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
      } catch (e) {
        emit(AuthenticationState.unauthenticated);
      }
      emit(AuthenticationState.authenticated);
    });

    on<AnonymousSignInRequested>((event, emit) async {
      emit(AuthenticationState.authenticating);
      try {
        await _firebaseAuth.signInAnonymously();
      } catch (e) {
        emit(AuthenticationState.unauthenticated);
      }
      emit(AuthenticationState.authenticated);
    });

    on<AuthenticationUserChanged>((event, emit) {
      emit(AuthenticationState.authenticated);
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthenticationState.authenticating);
      if (_firebaseAuth.currentUser != null) {
        if (_firebaseAuth.currentUser!.isAnonymous) {
          await _firebaseAuth.currentUser!.delete();
        } else {
          await _googleSignIn.signOut();
          await _firebaseAuth.signOut();
        }
      }
      emit(AuthenticationState.unauthenticated);
    });
  }
}
