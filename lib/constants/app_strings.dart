/// UI string constants for auth screens.
/// All user-visible strings live here to support future l10n and
/// to avoid hardcoding copy across multiple widget files.
library;

class AppStrings {
  AppStrings._();

  // ---- Branding ----
  static const appName = 'Elyxer';
  static const appTagline = '"Dating Redefined"';

  // ---- Landing screen ----
  static const createAccount = 'Create my account';
  static const signIn = 'Sign in';

  // ---- Sign-in screen header ----
  static const signInCreateAccount = 'Sign In / Create Account';

  // ---- Auth button labels (single space — M5 fix) ----
  static const signInWithApple = 'Sign in with Apple';
  static const signInWithGoogle = 'Sign in with Google';
  static const signInWithPhone = 'Sign in with Phone number';

  // ---- Generic navigation ----
  static const back = 'Back';

  // ---- Loading overlay ----
  static const loadingCancelLabel = 'Cancel';

  // ---- Legal copy ----
  static const legalPrefix =
      'By creating an account or signing in, you agree to our ';
  static const termsOfService = 'Terms of Service';
  static const legalMiddle =
      '. Learn more on how we use your data in our ';
  static const privacyPolicy = 'Privacy Policy';
  static const legalConjunction = ' and ';
  static const cookiesPolicy = 'Cookies Policy';
  static const legalSuffix = '.';

  // ---- Legal URLs (replace with production endpoints) ----
  static const termsUrl = 'https://elyxer.app/terms';
  static const privacyUrl = 'https://elyxer.app/privacy';
  static const cookiesUrl = 'https://elyxer.app/cookies';
}
