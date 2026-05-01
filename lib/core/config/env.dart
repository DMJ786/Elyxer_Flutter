/// Compile-time environment configuration.
///
/// All values are read via `String.fromEnvironment` so they're baked in
/// at build time via `--dart-define=KEY=value`. This avoids:
///   - bundling a `.env` file as an asset (conflicts with the
///     "never commit .env*" security rule in CLAUDE.md)
///   - shipping secrets through a runtime file load
///
/// See `env.example` in the repo root for the full list of args.
library;

class Env {
  Env._();

  /// Base URL of the Cloud Functions BFF.
  /// Override per environment with `--dart-define=API_BASE_URL=...`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://asia-south1-elyxer-dev.cloudfunctions.net',
  );

  /// Region where Cloud Functions are deployed. Used by the Firebase
  /// Functions SDK to route callable invocations.
  static const String cloudFunctionsRegion = String.fromEnvironment(
    'CLOUD_FUNCTIONS_REGION',
    defaultValue: 'asia-south1',
  );

  /// Mapbox public access token (client-safe; restricted by URL referrer
  /// in the Mapbox dashboard).
  static const String mapboxToken = String.fromEnvironment('MAPBOX_TOKEN');

  /// Google Places API key (client-safe; restricted by Android package
  /// name + SHA-1 / iOS bundle ID in Google Cloud Console).
  static const String googlePlacesKey = String.fromEnvironment('GOOGLE_PLACES_KEY');

  /// When true, Flutter points at the local Firebase emulator suite
  /// instead of production. Toggle with `--dart-define=USE_FIREBASE_EMULATOR=true`.
  /// Read by Bundle 1 (PR #2) when Firebase is wired in; defined here so PR #2
  /// only has to add the consumer side.
  static const bool useFirebaseEmulator = bool.fromEnvironment(
    'USE_FIREBASE_EMULATOR',
    defaultValue: false,
  );

  /// Returns true if the build is missing any value that's required at runtime.
  /// Useful for failing fast in `main()` rather than getting cryptic 401s.
  static List<String> missingRequired() {
    final missing = <String>[];
    if (mapboxToken.isEmpty) missing.add('MAPBOX_TOKEN');
    // googlePlacesKey is only strictly required for India users, so skip here.
    return missing;
  }
}
