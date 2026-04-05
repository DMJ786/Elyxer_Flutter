// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Verification Service Provider

@ProviderFor(verificationService)
const verificationServiceProvider = VerificationServiceProvider._();

/// Verification Service Provider

final class VerificationServiceProvider
    extends
        $FunctionalProvider<
          VerificationService,
          VerificationService,
          VerificationService
        >
    with $Provider<VerificationService> {
  /// Verification Service Provider
  const VerificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verificationServiceHash();

  @$internal
  @override
  $ProviderElement<VerificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VerificationService create(Ref ref) {
    return verificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerificationService>(value),
    );
  }
}

String _$verificationServiceHash() =>
    r'df13df0f2d9ed0fb3f37eaca615287bee5e2bc01';

/// Verification Data State Provider

@ProviderFor(VerificationDataNotifier)
const verificationDataProvider = VerificationDataNotifierProvider._();

/// Verification Data State Provider
final class VerificationDataNotifierProvider
    extends $NotifierProvider<VerificationDataNotifier, VerificationData?> {
  /// Verification Data State Provider
  const VerificationDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verificationDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verificationDataNotifierHash();

  @$internal
  @override
  VerificationDataNotifier create() => VerificationDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerificationData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerificationData?>(value),
    );
  }
}

String _$verificationDataNotifierHash() =>
    r'638f23abbcf37e82fcddcba3eff42a1d94172beb';

/// Verification Data State Provider

abstract class _$VerificationDataNotifier extends $Notifier<VerificationData?> {
  VerificationData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VerificationData?, VerificationData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VerificationData?, VerificationData?>,
              VerificationData?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Phone Input Provider

@ProviderFor(PhoneInputNotifier)
const phoneInputProvider = PhoneInputNotifierProvider._();

/// Phone Input Provider
final class PhoneInputNotifierProvider
    extends $NotifierProvider<PhoneInputNotifier, PhoneInputData?> {
  /// Phone Input Provider
  const PhoneInputNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneInputProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneInputNotifierHash();

  @$internal
  @override
  PhoneInputNotifier create() => PhoneInputNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneInputData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneInputData?>(value),
    );
  }
}

String _$phoneInputNotifierHash() =>
    r'20b6926959270dc1cf874eac46d95d04ade87a96';

/// Phone Input Provider

abstract class _$PhoneInputNotifier extends $Notifier<PhoneInputData?> {
  PhoneInputData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhoneInputData?, PhoneInputData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneInputData?, PhoneInputData?>,
              PhoneInputData?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Username Provider

@ProviderFor(UsernameNotifier)
const usernameProvider = UsernameNotifierProvider._();

/// Username Provider
final class UsernameNotifierProvider
    extends $NotifierProvider<UsernameNotifier, UsernameData?> {
  /// Username Provider
  const UsernameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usernameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usernameNotifierHash();

  @$internal
  @override
  UsernameNotifier create() => UsernameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsernameData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsernameData?>(value),
    );
  }
}

String _$usernameNotifierHash() => r'2b107f167c7f527681307bfc5140489b8b849582';

/// Username Provider

abstract class _$UsernameNotifier extends $Notifier<UsernameData?> {
  UsernameData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UsernameData?, UsernameData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UsernameData?, UsernameData?>,
              UsernameData?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Email Input Provider

@ProviderFor(EmailInputNotifier)
const emailInputProvider = EmailInputNotifierProvider._();

/// Email Input Provider
final class EmailInputNotifierProvider
    extends $NotifierProvider<EmailInputNotifier, EmailInputData?> {
  /// Email Input Provider
  const EmailInputNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailInputProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailInputNotifierHash();

  @$internal
  @override
  EmailInputNotifier create() => EmailInputNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmailInputData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmailInputData?>(value),
    );
  }
}

String _$emailInputNotifierHash() =>
    r'7d880a41b36dcbfba56a04f90955a35c437f7251';

/// Email Input Provider

abstract class _$EmailInputNotifier extends $Notifier<EmailInputData?> {
  EmailInputData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EmailInputData?, EmailInputData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmailInputData?, EmailInputData?>,
              EmailInputData?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Email Skipped Provider - tracks if user skipped email entry

@ProviderFor(EmailSkippedNotifier)
const emailSkippedProvider = EmailSkippedNotifierProvider._();

/// Email Skipped Provider - tracks if user skipped email entry
final class EmailSkippedNotifierProvider
    extends $NotifierProvider<EmailSkippedNotifier, bool> {
  /// Email Skipped Provider - tracks if user skipped email entry
  const EmailSkippedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailSkippedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailSkippedNotifierHash();

  @$internal
  @override
  EmailSkippedNotifier create() => EmailSkippedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$emailSkippedNotifierHash() =>
    r'6c415da287aae29082f7255c04f7da3245c8ae94';

/// Email Skipped Provider - tracks if user skipped email entry

abstract class _$EmailSkippedNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// OTP Timer Provider (for phone verification)

@ProviderFor(PhoneOTPTimer)
const phoneOTPTimerProvider = PhoneOTPTimerProvider._();

/// OTP Timer Provider (for phone verification)
final class PhoneOTPTimerProvider
    extends $NotifierProvider<PhoneOTPTimer, OTPTimerState> {
  /// OTP Timer Provider (for phone verification)
  const PhoneOTPTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneOTPTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneOTPTimerHash();

  @$internal
  @override
  PhoneOTPTimer create() => PhoneOTPTimer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OTPTimerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OTPTimerState>(value),
    );
  }
}

String _$phoneOTPTimerHash() => r'46413317d9a5eb9f6a1a85c9dc5b934e15053517';

/// OTP Timer Provider (for phone verification)

abstract class _$PhoneOTPTimer extends $Notifier<OTPTimerState> {
  OTPTimerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OTPTimerState, OTPTimerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OTPTimerState, OTPTimerState>,
              OTPTimerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// OTP Timer Provider (for email verification)

@ProviderFor(EmailOTPTimer)
const emailOTPTimerProvider = EmailOTPTimerProvider._();

/// OTP Timer Provider (for email verification)
final class EmailOTPTimerProvider
    extends $NotifierProvider<EmailOTPTimer, OTPTimerState> {
  /// OTP Timer Provider (for email verification)
  const EmailOTPTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emailOTPTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emailOTPTimerHash();

  @$internal
  @override
  EmailOTPTimer create() => EmailOTPTimer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OTPTimerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OTPTimerState>(value),
    );
  }
}

String _$emailOTPTimerHash() => r'9d8c31d52087fc4bc86334f69515e449676fb44a';

/// OTP Timer Provider (for email verification)

abstract class _$EmailOTPTimer extends $Notifier<OTPTimerState> {
  OTPTimerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OTPTimerState, OTPTimerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OTPTimerState, OTPTimerState>,
              OTPTimerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Send Phone OTP Provider

@ProviderFor(sendPhoneOTP)
const sendPhoneOTPProvider = SendPhoneOTPFamily._();

/// Send Phone OTP Provider

final class SendPhoneOTPProvider
    extends
        $FunctionalProvider<
          AsyncValue<SendOTPResponse>,
          SendOTPResponse,
          FutureOr<SendOTPResponse>
        >
    with $FutureModifier<SendOTPResponse>, $FutureProvider<SendOTPResponse> {
  /// Send Phone OTP Provider
  const SendPhoneOTPProvider._({
    required SendPhoneOTPFamily super.from,
    required PhoneInputData super.argument,
  }) : super(
         retry: null,
         name: r'sendPhoneOTPProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sendPhoneOTPHash();

  @override
  String toString() {
    return r'sendPhoneOTPProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SendOTPResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SendOTPResponse> create(Ref ref) {
    final argument = this.argument as PhoneInputData;
    return sendPhoneOTP(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SendPhoneOTPProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sendPhoneOTPHash() => r'cd13b01c00a44eae24b8f9ee6e087375fdfbdd70';

/// Send Phone OTP Provider

final class SendPhoneOTPFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SendOTPResponse>, PhoneInputData> {
  const SendPhoneOTPFamily._()
    : super(
        retry: null,
        name: r'sendPhoneOTPProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Send Phone OTP Provider

  SendPhoneOTPProvider call(PhoneInputData phoneData) =>
      SendPhoneOTPProvider._(argument: phoneData, from: this);

  @override
  String toString() => r'sendPhoneOTPProvider';
}

/// Verify Phone OTP Provider

@ProviderFor(verifyPhoneOTP)
const verifyPhoneOTPProvider = VerifyPhoneOTPFamily._();

/// Verify Phone OTP Provider

final class VerifyPhoneOTPProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerifyOTPResponse>,
          VerifyOTPResponse,
          FutureOr<VerifyOTPResponse>
        >
    with
        $FutureModifier<VerifyOTPResponse>,
        $FutureProvider<VerifyOTPResponse> {
  /// Verify Phone OTP Provider
  const VerifyPhoneOTPProvider._({
    required VerifyPhoneOTPFamily super.from,
    required (PhoneInputData, String) super.argument,
  }) : super(
         retry: null,
         name: r'verifyPhoneOTPProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verifyPhoneOTPHash();

  @override
  String toString() {
    return r'verifyPhoneOTPProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<VerifyOTPResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerifyOTPResponse> create(Ref ref) {
    final argument = this.argument as (PhoneInputData, String);
    return verifyPhoneOTP(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyPhoneOTPProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verifyPhoneOTPHash() => r'fa6957743425823019cc8471c7376d33c08c6d33';

/// Verify Phone OTP Provider

final class VerifyPhoneOTPFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<VerifyOTPResponse>,
          (PhoneInputData, String)
        > {
  const VerifyPhoneOTPFamily._()
    : super(
        retry: null,
        name: r'verifyPhoneOTPProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Verify Phone OTP Provider

  VerifyPhoneOTPProvider call(PhoneInputData phoneData, String code) =>
      VerifyPhoneOTPProvider._(argument: (phoneData, code), from: this);

  @override
  String toString() => r'verifyPhoneOTPProvider';
}

/// Submit Username Provider

@ProviderFor(submitUsername)
const submitUsernameProvider = SubmitUsernameFamily._();

/// Submit Username Provider

final class SubmitUsernameProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Submit Username Provider
  const SubmitUsernameProvider._({
    required SubmitUsernameFamily super.from,
    required UsernameData super.argument,
  }) : super(
         retry: null,
         name: r'submitUsernameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submitUsernameHash();

  @override
  String toString() {
    return r'submitUsernameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as UsernameData;
    return submitUsername(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitUsernameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submitUsernameHash() => r'26ef3d44d098537aba368a615174b1775f4106b7';

/// Submit Username Provider

final class SubmitUsernameFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, UsernameData> {
  const SubmitUsernameFamily._()
    : super(
        retry: null,
        name: r'submitUsernameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Submit Username Provider

  SubmitUsernameProvider call(UsernameData usernameData) =>
      SubmitUsernameProvider._(argument: usernameData, from: this);

  @override
  String toString() => r'submitUsernameProvider';
}

/// Send Email OTP Provider

@ProviderFor(sendEmailOTP)
const sendEmailOTPProvider = SendEmailOTPFamily._();

/// Send Email OTP Provider

final class SendEmailOTPProvider
    extends
        $FunctionalProvider<
          AsyncValue<SendOTPResponse>,
          SendOTPResponse,
          FutureOr<SendOTPResponse>
        >
    with $FutureModifier<SendOTPResponse>, $FutureProvider<SendOTPResponse> {
  /// Send Email OTP Provider
  const SendEmailOTPProvider._({
    required SendEmailOTPFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sendEmailOTPProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sendEmailOTPHash();

  @override
  String toString() {
    return r'sendEmailOTPProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SendOTPResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SendOTPResponse> create(Ref ref) {
    final argument = this.argument as String;
    return sendEmailOTP(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SendEmailOTPProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sendEmailOTPHash() => r'a710660eada349885e51cae52ae341663ac47730';

/// Send Email OTP Provider

final class SendEmailOTPFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SendOTPResponse>, String> {
  const SendEmailOTPFamily._()
    : super(
        retry: null,
        name: r'sendEmailOTPProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Send Email OTP Provider

  SendEmailOTPProvider call(String email) =>
      SendEmailOTPProvider._(argument: email, from: this);

  @override
  String toString() => r'sendEmailOTPProvider';
}

/// Verify Email OTP Provider

@ProviderFor(verifyEmailOTP)
const verifyEmailOTPProvider = VerifyEmailOTPFamily._();

/// Verify Email OTP Provider

final class VerifyEmailOTPProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerifyOTPResponse>,
          VerifyOTPResponse,
          FutureOr<VerifyOTPResponse>
        >
    with
        $FutureModifier<VerifyOTPResponse>,
        $FutureProvider<VerifyOTPResponse> {
  /// Verify Email OTP Provider
  const VerifyEmailOTPProvider._({
    required VerifyEmailOTPFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'verifyEmailOTPProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verifyEmailOTPHash();

  @override
  String toString() {
    return r'verifyEmailOTPProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<VerifyOTPResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerifyOTPResponse> create(Ref ref) {
    final argument = this.argument as (String, String);
    return verifyEmailOTP(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is VerifyEmailOTPProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verifyEmailOTPHash() => r'd1b635f2e3976274a87afef842ebb1ff909a11f3';

/// Verify Email OTP Provider

final class VerifyEmailOTPFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<VerifyOTPResponse>,
          (String, String)
        > {
  const VerifyEmailOTPFamily._()
    : super(
        retry: null,
        name: r'verifyEmailOTPProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Verify Email OTP Provider

  VerifyEmailOTPProvider call(String email, String code) =>
      VerifyEmailOTPProvider._(argument: (email, code), from: this);

  @override
  String toString() => r'verifyEmailOTPProvider';
}

/// Submit Email Preferences Provider

@ProviderFor(submitEmailPreferences)
const submitEmailPreferencesProvider = SubmitEmailPreferencesFamily._();

/// Submit Email Preferences Provider

final class SubmitEmailPreferencesProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Submit Email Preferences Provider
  const SubmitEmailPreferencesProvider._({
    required SubmitEmailPreferencesFamily super.from,
    required EmailInputData super.argument,
  }) : super(
         retry: null,
         name: r'submitEmailPreferencesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submitEmailPreferencesHash();

  @override
  String toString() {
    return r'submitEmailPreferencesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as EmailInputData;
    return submitEmailPreferences(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitEmailPreferencesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submitEmailPreferencesHash() =>
    r'89417598c7c6e39a5b288777809877c63c8202e4';

/// Submit Email Preferences Provider

final class SubmitEmailPreferencesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, EmailInputData> {
  const SubmitEmailPreferencesFamily._()
    : super(
        retry: null,
        name: r'submitEmailPreferencesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Submit Email Preferences Provider

  SubmitEmailPreferencesProvider call(EmailInputData emailData) =>
      SubmitEmailPreferencesProvider._(argument: emailData, from: this);

  @override
  String toString() => r'submitEmailPreferencesProvider';
}
