# Data Storage Analysis: Elyxer Dating App

**Date:** 2026-02-16
**Status:** Research & Planning
**Related:** CLAUDE.md High Priority #1 - Replace in-memory repositories with persistent storage

---

## Table of Contents

1. [Current App Storage Status](#1-current-app-storage-status)
2. [Industry Analysis: How Top Dating Apps Store Data](#2-industry-analysis-how-top-dating-apps-store-data)
3. [Local Storage Patterns](#3-local-storage-patterns)
4. [Authentication & Token Storage](#4-authentication--token-storage)
5. [Onboarding Data Submission](#5-onboarding-data-submission)
6. [Profile Data Sync](#6-profile-data-sync)
7. [Image & Media Storage](#7-image--media-storage)
8. [Backend Tech Stacks](#8-backend-tech-stacks)
9. [Offline Support](#9-offline-support)
10. [Caching Strategies](#10-caching-strategies)
11. [Security & GDPR Compliance](#11-security--gdpr-compliance)
12. [Recommended Architecture for Elyxer](#12-recommended-architecture-for-elyxer)

---

## 1. Current App Storage Status

### Overview

The app currently has **NO persistent storage**. All data lives in-memory via Riverpod providers and is lost on app restart.

### Current Data Flow

| Screen | Data Captured | Storage | Persistence |
|---|---|---|---|
| Phone Input | countryCode, phoneNumber | Riverpod (in-memory) | Lost on app restart |
| Phone OTP | OTP code | Riverpod (in-memory) | Lost on app restart |
| Username | firstName, lastName | Riverpod (in-memory, keepAlive) | Lost on app restart |
| Email Input | email, enableNotifications | Riverpod (in-memory, keepAlive) | Lost on app restart |
| Email OTP | OTP code | Riverpod (in-memory) | Lost on app restart |
| Onboarding | Age, gender, pronouns | Riverpod (in-memory, keepAlive) | Lost on app restart |
| Orientation | Sexual orientation, dating preferences, goals | Riverpod (in-memory, keepAlive) | Lost on app restart |

### Current Dependencies (from pubspec.yaml)

```
State Management:
  - flutter_riverpod: ^3.0.3
  - riverpod_annotation: ^3.0.3
  - hooks_riverpod: ^3.0.3

Serialization:
  - json_serializable: ^6.7.1
  - freezed: ^3.2.3

Missing Storage Dependencies:
  x SQLite / sqflite / Drift      (not present)
  x Hive / Isar                   (not present)
  x SharedPreferences             (not present)
  x flutter_secure_storage        (not present)
  x Dio / HTTP client             (not present)
```

### Current Backend Integration

**Status: Fully Mocked**

All API calls in `lib/services/verification_service.dart` return mock responses after a 1-second delay. No real HTTP client is configured.

```
Mock Endpoints (not implemented):
  - POST /auth/send-phone-otp
  - POST /auth/verify-phone-otp
  - POST /auth/username
  - POST /auth/send-email-otp
  - POST /auth/verify-email-otp
  - POST /auth/email-preferences
```

### Current Provider Architecture

```
lib/providers/verification_provider.dart
  ├── phoneInputProvider         (keepAlive: true)
  ├── usernameProvider           (keepAlive: true)
  ├── emailInputProvider         (keepAlive: true)
  ├── phoneOTPTimer              (ephemeral)
  └── emailOTPTimer              (ephemeral)

lib/providers/onboarding_provider.dart
  ├── currentOnboardingStepProvider    (keepAlive: true)
  ├── currentOrientationStepProvider   (keepAlive: true)
  └── onboardingDataProvider           (keepAlive: true)
```

> **Note:** `keepAlive: true` means the provider state is NOT disposed until the app is closed, but data is still **not persisted to disk**.

---

## 2. Industry Analysis: How Top Dating Apps Store Data

### What Dating Apps Store Locally

| Data Type | Storage Mechanism | Purpose |
|---|---|---|
| Auth tokens (access + refresh) | Keychain (iOS) / Keystore (Android) / flutter_secure_storage | Secure session persistence |
| User profile (own) | SQLite / Room / Core Data | Offline access to own profile |
| Preferences (filters, distance, age) | SharedPreferences / UserDefaults / Hive | Instant filter application without API roundtrip |
| Cached profile cards | SQLite + disk cache for images | Smooth swiping UX, pre-fetched deck of 10-20 cards |
| Match list (recent) | SQLite / Room | Quick display of match list on app open |
| Message drafts | SQLite | Preserve unsent messages |
| App settings (theme, notifications) | SharedPreferences / UserDefaults | UX preferences |
| Swipe history (recent) | In-memory or lightweight SQLite | Undo feature, prevent re-showing |
| Feature flags / remote config | SharedPreferences with TTL | A/B testing, feature rollouts |

### What is NOT Stored Locally

- Full message history (fetched paginated from server)
- Other users' full profile data (only cached temporarily)
- Payment/subscription details (server-side, only status cached)
- Algorithm/scoring data

---

## 3. Local Storage Patterns

### Database Choices by Platform

| Platform | Database | Notes |
|---|---|---|
| Native iOS | Core Data or Realm | Tinder historically used Core Data |
| Native Android | Room (SQLite abstraction) or Realm | Standard Android approach |
| Flutter | Hive, Isar, sqflite, or Drift | Drift recommended for typed SQLite |
| React Native | WatermelonDB, MMKV | AsyncStorage deprecated for sensitive data |

### Multi-Layer Storage Architecture

```
Layer 1: Secure Storage (flutter_secure_storage)
  └── Auth tokens, encryption keys, sensitive credentials

Layer 2: Local Database (SQLite via Drift, or Hive)
  └── User profile, matches, messages, cached profiles

Layer 3: Key-Value Store (SharedPreferences)
  └── App settings, preferences, feature flags, onboarding progress

Layer 4: Disk Cache (cached_network_image)
  └── Profile photos, media files (LRU eviction, 200-500MB cap)

Layer 5: In-Memory (Riverpod)
  └── Current session state, active conversation, discovery deck
```

---

## 4. Authentication & Token Storage

### Secure Storage by Platform

| Platform | Secure Storage | Details |
|---|---|---|
| iOS | Keychain Services | Hardware-backed on devices with Secure Enclave |
| Android | Android Keystore + EncryptedSharedPreferences | Hardware-backed keystore on modern devices |
| Flutter | flutter_secure_storage | Wraps Keychain (iOS) and EncryptedSharedPreferences (Android) |

### Token Architecture (Industry Standard)

```
Access Token:  Short-lived (15-30 min), JWT, stored in memory + secure storage
Refresh Token: Long-lived (30-90 days), opaque token, stored ONLY in secure storage
Device Token:  Persistent device identifier for fraud detection

Flow:
  1. Login -> server returns { accessToken, refreshToken }
  2. Access token used for all API calls (Authorization: Bearer <token>)
  3. On 401 -> use refresh token to get new access token
  4. On refresh failure -> force re-login
  5. Refresh tokens are rotated on each use (one-time use)
```

### Additional Security Measures

- Certificate pinning (Tinder and Bumble both implement this)
- Token binding to device fingerprint
- Biometric authentication for token access (Face ID / Touch ID)
- No tokens stored in plain text, ever

---

## 5. Onboarding Data Submission

### Industry Approach: Progressive Save with Server-Side Drafts

Most dating apps save onboarding data **step-by-step**, not as a batch:

```
Step 1: Phone/email verify  -> Account created server-side immediately
Step 2: Name, birthday      -> PATCH /api/v1/profile (partial update)
Step 3: Gender, pronouns    -> PATCH /api/v1/profile
Step 4: Photos              -> POST /api/v1/profile/photos (uploaded immediately)
Step 5: Orientation/prefs   -> PATCH /api/v1/profile/preferences
Step 6: Dating goals        -> PATCH /api/v1/profile/preferences
Step 7: Location permission -> POST /api/v1/location
Final:  POST /api/v1/profile/activate (marks profile as discoverable)
```

### Why Step-by-Step, Not Batch

- **Drop-off recovery:** If user abandons at step 4, the app resumes there. Tinder recovers ~15-20% of abandoned signups this way.
- **Photo upload latency:** Uploading 3-6 photos takes time. Upload as user adds them.
- **Validation:** Server validates each step (minimum age, photo moderation).
- **Local fallback:** Completed steps cached locally (SharedPreferences/Hive) and retried if network fails.

### Local Onboarding Cache Pattern

```dart
// Save progress locally after each step
class OnboardingCache {
  final SharedPreferences prefs;

  Future<void> saveProgress(int step, Map<String, dynamic> data) async {
    await prefs.setInt('onboarding_step', step);
    await prefs.setString('onboarding_data', jsonEncode(data));
  }

  int getLastCompletedStep() => prefs.getInt('onboarding_step') ?? 0;

  Map<String, dynamic>? getSavedData() {
    final data = prefs.getString('onboarding_data');
    return data != null ? jsonDecode(data) : null;
  }

  Future<void> clear() async {
    await prefs.remove('onboarding_step');
    await prefs.remove('onboarding_data');
  }
}
```

---

## 6. Profile Data Sync

### Pattern: Server-Authoritative with Local Cache + Optimistic Updates

**Server is the single source of truth. Local storage is a performance cache.**

### Read Flow

```
1. App opens -> display locally cached profile immediately
2. Background fetch: GET /api/v1/profile (with ETag / If-Modified-Since)
3. If changed -> update local cache, update UI
4. If 304 Not Modified -> no action
```

### Write Flow (Optimistic Update)

```
1. User edits bio -> update local cache immediately, update UI
2. Send PATCH /api/v1/profile { bio: "new bio" } in background
3. On success -> confirm local state, update lastSyncedAt
4. On failure -> revert local cache, show error toast, offer retry
```

### Conflict Resolution

- **Last-write-wins** for profile data (user can only edit their own)
- **Server timestamp** for ordering
- **ETags** prevent stale overwrites

### Discovery Feed (Other Profiles)

- Pre-fetched in batches of 10-20 profiles
- Cached in SQLite with short TTL
- Images cached separately in disk cache (LRU eviction)
- Prefetch next batch when deck drops below 3-5 remaining cards

### Messages

- Real-time delivery via WebSocket
- Persisted to local SQLite on receipt
- Paginated fetch from server for history (cursor-based)
- Read receipts synced via WebSocket

---

## 7. Image & Media Storage

### Upload Flow

```
1. User selects photo
2. Client-side:
   - Compress (JPEG quality 70-85%, max 1080px width)
   - Generate thumbnail locally for immediate preview
   - Optional: client-side NSFW detection (on-device ML)
3. Upload:
   - Request pre-signed URL: POST /api/v1/photos/upload-url
   - Upload directly to S3/GCS using pre-signed URL (bypasses app server)
4. Server-side processing (async, triggered by S3 event):
   - Generate sizes: thumbnail (150px), card (600px), full (1080px)
   - NSFW/content moderation (AWS Rekognition, Google Vision)
   - Face detection (ensure photo contains a face)
   - EXIF stripping (remove GPS data for privacy)
5. CDN delivery:
   - Images served via CDN (CloudFront, Cloudflare)
   - URL format: https://images.app.com/{userId}/{size}/{photoId}.jpg
```

### Storage Infrastructure

| Component | Technology |
|---|---|
| Cloud storage | Amazon S3, Google Cloud Storage |
| CDN | CloudFront (AWS), Cloud CDN (GCP), Cloudflare |
| Image processing | AWS Lambda + Sharp, Imgix, Cloudinary |
| Client caching | cached_network_image (Flutter), LRU disk cache (200-500MB) |

---

## 8. Backend Tech Stacks

### Major Dating Apps

| App | Backend | Database | Infrastructure |
|---|---|---|---|
| **Tinder** | Java/Kotlin microservices | DynamoDB + Redis + Redshift | AWS (Kubernetes) |
| **Bumble** | Go microservices | PostgreSQL + Redis + Elasticsearch | GCP |
| **Hinge** | Kotlin (shared Match Group infra) | DynamoDB + Redis | AWS |

### Recommended Stacks by Stage

#### MVP / Startup

```
Backend:    Firebase (Auth + Firestore + Cloud Functions + Storage)
Advantages: Fast to build, real-time sync built-in, cheap at small scale
Risks:      Vendor lock-in, costs scale poorly, limited query flexibility
```

#### Growth Stage

```
Backend:    Node.js or Go + PostgreSQL + Redis
Search:     Elasticsearch or PostGIS for geospatial queries
Queue:      RabbitMQ or SQS
Storage:    S3 + CloudFront
Auth:       Auth0 or custom JWT
```

#### Scale

```
Backend:    Microservices (Go/Java/Kotlin)
Databases:  PostgreSQL (profiles) + DynamoDB (messages) + Redis (cache)
Streaming:  Kafka
Search:     Elasticsearch with geospatial
ML:         Python/Spark for matching algorithms
Infra:      Kubernetes on AWS/GCP
```

### Geospatial Querying (Core to Dating Apps)

| Technology | Use Case |
|---|---|
| PostgreSQL + PostGIS | Most common for startups |
| MongoDB 2dsphere indexes | Alternative NoSQL approach |
| Elasticsearch geo_distance | Search + geo combined |
| Redis GEOADD/GEOSEARCH | Real-time proximity |
| DynamoDB + geohash | Tinder's approach at scale |

---

## 9. Offline Support

### What Works Offline

- Viewing own profile (cached locally)
- Viewing cached matches list
- Reading cached messages
- Composing message drafts (queued for send)
- Viewing pre-fetched discovery cards (limited deck)
- Editing preferences (synced on reconnect)

### What Does Not Work Offline

- Discovering new profiles (beyond cached deck)
- Sending messages (queued but not delivered)
- Receiving new matches or messages
- Location updates
- Photo uploads

### Offline Queue Pattern

```dart
class OfflineQueue {
  final Database db;

  Future<void> enqueue(PendingAction action) async {
    await db.insert('pending_actions', {
      'type': action.type,        // 'swipe', 'message', 'profile_update'
      'payload': jsonEncode(action.payload),
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
  }

  Future<void> processQueue() async {
    final pending = await db.query('pending_actions', orderBy: 'created_at ASC');
    for (final action in pending) {
      try {
        await apiClient.send(action);
        await db.delete('pending_actions', where: 'id = ?', args: [action.id]);
      } catch (e) {
        await db.update('pending_actions',
          {'retry_count': action.retryCount + 1},
          where: 'id = ?', args: [action.id]);
      }
    }
  }
}
```

### Connectivity Handling

- Monitor network state (connectivity_plus in Flutter)
- UI indicators when offline ("No connection" banner)
- Automatic queue processing when connection resumes
- Swipe actions queued immediately (lost swipe = bad UX)

---

## 10. Caching Strategies

### Multi-Layer Caching Architecture

```
Layer 1: In-Memory (app process)
  - Current discovery deck (10-20 profiles)
  - Active conversation messages
  - User session state
  - TTL: lifetime of app session

Layer 2: Local Disk Cache (SQLite)
  - Profile data, match list, message history
  - TTL: varies (profiles: hours, messages: persistent)

Layer 3: Disk Image Cache (LRU)
  - Profile photos
  - 200-500MB cap with LRU eviction
  - TTL: days

Layer 4: Server-Side Cache (Redis)
  - User sessions, discovery queue, rate limiting, online status
  - TTL: seconds to hours

Layer 5: CDN Cache (CloudFront/Cloudflare)
  - Profile images (edge-cached globally)
  - Static assets
  - TTL: hours to days (cache busted on photo change)
```

### Discovery Cards (Swipe Deck)

- Pre-fetch next batch when deck drops below 5 remaining
- Server pre-computes recommendation queue per user (Redis)
- Client caches card data in memory + images on disk
- Cards NOT cached long-term (recommendations change)
- Prefetch images for top 3-5 cards for instant display

### Messages

- Persisted in local SQLite
- New messages via WebSocket -> insert into SQLite -> notify UI
- History loaded on-demand with backward pagination (cursor-based)
- Typing indicators: purely real-time (WebSocket), never cached

---

## 11. Security & GDPR Compliance

### Encryption at Rest

| Layer | Implementation |
|---|---|
| SQLite database | SQLCipher (256-bit AES encrypted SQLite) |
| Shared preferences | EncryptedSharedPreferences (Android), Keychain (iOS) |
| Image cache | OS-level file protection (iOS Data Protection API) |
| Full disk | iOS: NSFileProtectionComplete, Android: File-Based Encryption |

### Encryption in Transit

- TLS 1.2+ mandatory (TLS 1.3 preferred)
- Certificate pinning (Tinder, Bumble, Hinge all implement this)
- Perfect Forward Secrecy (PFS) cipher suites

### GDPR Compliance (Critical for Dating Apps)

Dating app data (sexual orientation, location, photos) falls under the **most sensitive personal data categories**.

| Requirement | Implementation |
|---|---|
| Right to Access | `GET /api/v1/privacy/export` -> downloadable data archive |
| Right to Erasure | `DELETE /api/v1/account` -> full data deletion within 30 days |
| Consent management | Granular opt-in for each data processing purpose |
| Data minimization | Only collect what is necessary |
| Location data | Special handling (considered sensitive under GDPR) |
| Sexual orientation | **"Special category data"** under GDPR Article 9 - requires **explicit consent** |
| Data portability | Export in machine-readable format (JSON/CSV) |
| Breach notification | 72-hour notification requirement |

### Dating-App-Specific Security

- **Location obfuscation:** Never expose exact coordinates (Tinder rounds to ~1 mile grid)
- **Screenshot detection** for private content
- **Report/block system** with server-side enforcement
- **Photo verification** (selfie comparison via ML)
- **Age verification** (varies by jurisdiction)
- **EXIF stripping** from uploaded photos (remove GPS metadata)

---

## 12. Recommended Architecture for Elyxer

### Phase 1: Immediate (Local Storage Foundation)

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0    # Auth tokens
  shared_preferences: ^2.2.0        # Simple preferences, onboarding progress
  hive_flutter: ^1.1.0              # Local NoSQL database
  dio: ^5.4.0                       # HTTP client
  connectivity_plus: ^5.0.0         # Network detection
```

Implementation:

```
1. flutter_secure_storage
   - Store auth tokens (access + refresh)
   - Store encryption keys

2. SharedPreferences
   - Onboarding progress (last completed step)
   - App settings (theme, notifications)
   - Feature flags

3. Hive
   - User profile cache
   - Onboarding data (persisted between app restarts)

4. Dio
   - Replace mock VerificationService with real HTTP calls
   - Add interceptors for auth token injection
   - Add retry logic with exponential backoff
```

### Phase 2: Backend Integration

```
PostgreSQL + PostGIS    -> User profiles, geospatial queries
Redis                   -> Sessions, caching, online status
S3 + CloudFront         -> Photo storage + CDN
WebSocket               -> Real-time messaging
JWT Authentication      -> Access + refresh token flow
```

### Phase 3: Production-Ready

```
SQLCipher               -> Encrypted local database
Certificate pinning     -> MITM protection
Offline queue           -> Queue actions when offline, process on reconnect
Progressive onboarding  -> Save each step to server
GDPR compliance         -> Data export, deletion, consent management
Image pipeline          -> Pre-signed upload, server-side processing, CDN delivery
```

### Suggested Project Structure

```
lib/
├── data/
│   ├── local/
│   │   ├── secure_storage.dart         # Token storage
│   │   ├── preferences_storage.dart    # SharedPreferences wrapper
│   │   └── hive_database.dart          # Hive setup and boxes
│   ├── remote/
│   │   ├── api_client.dart             # Dio configuration
│   │   ├── auth_interceptor.dart       # Token injection
│   │   └── endpoints/
│   │       ├── auth_api.dart
│   │       ├── profile_api.dart
│   │       └── discovery_api.dart
│   └── repositories/
│       ├── auth_repository.dart        # Combines local + remote
│       ├── profile_repository.dart
│       └── onboarding_repository.dart
├── models/                             # (existing)
├── providers/                          # (existing, updated to use repositories)
├── screens/                            # (existing)
├── services/                           # (existing, refactored)
└── widgets/                            # (existing)
```

---

## Key Takeaways

1. **Use platform-native secure storage for tokens** - never plain SharedPreferences for sensitive data
2. **Server is the source of truth** - local storage is a performance cache
3. **Upload images directly to cloud storage** via pre-signed URLs, not through your API server
4. **Pre-fetch the discovery deck** - swiping must feel instant
5. **Use WebSockets for messaging** - polling is unacceptable for chat
6. **Onboarding should save progressively** - do not batch at the end
7. **GDPR is non-negotiable** - sexual orientation is "special category data"
8. **Start with PostgreSQL + PostGIS + Redis + S3** - covers 95% of needs at startup to mid-scale
9. **SQLite with SQLCipher** is the standard for non-trivial local cached data
10. **Encrypt everything** - at rest and in transit
