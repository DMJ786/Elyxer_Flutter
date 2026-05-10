/// App-wide string constants
/// All user-visible strings live here to ease future l10n
library;

class AppStrings {
  AppStrings._();

  // Brand
  static const appName = 'Elyxer';
  static const appTagline = 'Connect with intention';

  // Landing screen
  static const createAccount = 'Create an Account';
  static const signIn = 'Sign In';

  // Sign-in screen header
  static const signInCreateAccount = 'Sign In / Create Account';

  // Auth buttons
  static const signInWithApple = 'Continue with Apple';
  static const signInWithGoogle = 'Continue with Google';
  static const signInWithPhone = 'Continue with Phone';

  // Common
  static const back = 'Back';
  static const loadingCancelLabel = 'Cancel';

  // Legal (landing + sign-in footer)
  static const legalText =
      'By continuing, you agree to Elyxer\'s Terms of Service and Privacy Policy.';
}
