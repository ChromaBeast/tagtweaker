import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Custom exception for Google Sign-In errors
class GoogleSignInException implements Exception {
  final String message;
  GoogleSignInException([this.message = 'Google Sign-In failed']);

  @override
  String toString() => message;
}

/// Service class to handle Google Sign-In authentication (v7.2.0+)
class GoogleSignInService {
  GoogleSignInService._();
  static final GoogleSignInService instance = GoogleSignInService._();

  /// Must use instance in v7.2.0+
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _authenticatedUser;
  bool _isInitialized = false;

  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  final _userController = StreamController<GoogleSignInAccount?>.broadcast();

  Stream<GoogleSignInAccount?> get userStream => _userController.stream;
  GoogleSignInAccount? get currentUser => _authenticatedUser;
  bool get isSignedIn => _authenticatedUser != null;

  Future<void> initialize({
    String? clientId,
    String? serverClientId,
    List<String> scopes = const ['email', 'profile'],
  }) async {
    if (_isInitialized) return;

    // Initialize config (this is new in v7)
    await _googleSignIn.initialize(
      clientId: clientId,
      serverClientId: serverClientId,
    );

    // Listen for sign-in + sign-out events
    _authSubscription = _googleSignIn.authenticationEvents.listen(
      _handleEvent,
      onError: _handleError,
    );

    _isInitialized = true;
    if (kDebugMode) print("GoogleSignIn v7.2.0 initialized");
  }

  void _handleEvent(GoogleSignInAuthenticationEvent event) {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      _authenticatedUser = event.user;
      _userController.add(event.user);
      if (kDebugMode) print("Signed in: ${event.user.email}");
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      _authenticatedUser = null;
      _userController.add(null);
      if (kDebugMode) print("Signed out");
    }
  }

  void _handleError(Object error) {
    _authenticatedUser = null;
    _userController.add(null);
    if (kDebugMode) print("GoogleSignIn error: $error");
  }

  /// Signs in the user with Google and returns a [UserCredential]
  /// Throws [GoogleSignInException] if sign-in is cancelled or fails
  /// Throws [FirebaseAuthException] if Firebase authentication fails
  Future<UserCredential> signInWithGoogle() async {
    if (!_isInitialized) {
      throw GoogleSignInException(
        "GoogleSignInService not initialized. Call initialize() first.",
      );
    }

    // Define scopes needed for Firebase Auth
    const scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ];

    // Launch Google Sign-In with scope hint
    await _googleSignIn.authenticate(scopeHint: scopes);

    // Wait for event
    final user = await userStream.firstWhere((u) => u != null);

    // Get authentication (idToken only)
    final googleAuthentication = user!.authentication;

    // Get authorization (accessToken)
    final googleAuthorization = await user.authorizationClient
        .authorizationForScopes(scopes);

    if (googleAuthorization == null) {
      throw GoogleSignInException(
        "Failed to get access token. Authorization not granted.",
      );
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthorization.accessToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Signs out from both Google and Firebase
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  /// Disconnects the Google account (revokes access)
  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }

  void dispose() {
    _authSubscription?.cancel();
    _userController.close();
  }
}
