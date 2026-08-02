# Chat Module — Sendbird On-Device Test Checklist

**Goal:** validate the real `SendbirdChatRepository` end-to-end on a device,
using the Sendbird dashboard as the "second user" — no second phone needed.
Confirms connect / channel / send / receive / typing / read receipts and the
**MAU/PCC cost behaviour**.

- **App:** Elyxer (branch `feature/chat-module-phase-a`)
- **Sendbird app:** Elyxer · Mumbai · App ID `A3438FE2-4C40-45A9-8F21-413FD12BBE7A`
- **Test user id (app):** `me` (hardcoded in the chat screens for now)
- **Test partner id (dashboard):** `asha`

> ⚠️ Sendbird runs on **mobile only** in this build (web uses the mock). You
> must run on an Android/iOS device or emulator, **not** Chrome.

---

## 0. Prerequisites

- [ ] An Android emulator/device or iOS simulator/device is available
      (`flutter devices` lists it)
- [ ] Logged in to the Sendbird dashboard for the **Elyxer** application
- [ ] On branch `feature/chat-module-phase-a`, `flutter pub get` has run

---

## 1. Dashboard pre-flight (2 min — do this first)

This catches the #1 false alarm: if session tokens are *required*, our trial
`connect(userId)` (no token) fails with an auth error and it looks like a code
bug.

- [ ] **Settings → Security → Access token permission** (or "Session token")
      is set to **"Read & write allowed without an access token"** (the
      permissive default). If it *requires* a token, switch it to permissive
      for the trial. *(Production flips this on + uses a server-minted token —
      tracked follow-up.)*
- [ ] **Settings → Application → General** — App ID matches the one above.

---

## 2. Point the app at the Chat screen (temporary)

The app boots at `/` (verification flow). For the test, land on chat directly:

- [ ] In `lib/routes/app_router.dart`, temporarily change:
      `initialLocation: '/'` → `initialLocation: '/chats'`
      **(revert this before committing / opening the PR — see §7)**

---

## 3. Dashboard: set up the conversation (the "second user")

- [ ] **Chat → Group channels → Create channel**
- [ ] Add members: **`me`** and **`asha`** (type the user ids; Sendbird
      auto-creates the users if they don't exist)
- [ ] Turn **Distinct** ON (so it matches what the app would create)
- [ ] Create it. Optionally give `asha` a nickname ("Asha") + profile image
      under **Users → asha** so the app shows a friendly name/avatar.

---

## 4. Run the app

```bash
flutter run -d <device-id>
```

- [ ] App launches on the device and lands on **Chats**
- [ ] **Dashboard → Overview:** **MAU ticks 0 → 1** and **PCC 0 → 1** within a
      few seconds of the screen opening
      → ✅ confirms the deferred-connect fired *and* the cost model
- [ ] The **Connections** row shows **Asha**; since the channel has no messages
      yet, **Conversations** shows the empty state ("No chats yet")

> If MAU/PCC stay at 0 or you see an auth error in the `flutter run` console
> → recheck §1 (token requirement) and the App ID.

---

## 5. Test scenarios

| # | Action (app unless noted) | Expected in app | Expected in dashboard |
|---|---|---|---|
| 5.1 | Tap **Asha** in Connections | Opens the conversation (empty, "Today" divider) | — |
| 5.2 | Type "Hello Asha" → **Send** | Bubble appears **once** (gold, right), status goes **Sending → Sent** | **Chat → the channel** shows the message from `me` |
| 5.3 | **Dashboard:** as `asha`, send "Hi there!" into the channel | Message arrives **in real time** (white bubble, left) | message listed as from `asha` |
| 5.4 | Type in the composer (don't send) | — | **channel → the typing event** fires (or member shows typing) |
| 5.5 | **Dashboard:** trigger/observe `asha` reading — or send another msg | Your earlier sent bubble status bumps **Sent → Read** | read receipt recorded |
| 5.6 | Go **back** to Chats | Asha now appears under **Conversations** with the last message + timestamp | unread/last-message updates |
| 5.7 | Kill + relaunch the app, open Asha | **History loads** (previous messages appear) | — |

**Watch specifically for (the bug we pre-fixed):**
- [ ] **5.2 — the sent message appears exactly ONCE**, not twice (pending +
      confirmed must collapse). If it double-shows, flag it.

**Core pass criteria:**
- [ ] 5.2 send works + status transitions
- [ ] 5.3 real-time receive works
- [ ] 5.4 typing event registered
- [ ] 5.5 read receipt bumps status
- [ ] 5.7 history loads on relaunch

---

## 6. Cost / usage verification (Dashboard → Overview)

- [ ] **MAU = 1** after one user connected (not more — proves dedup: many
      connects by `me` still count as 1)
- [ ] **PCC = 1** with one device connected (open a 2nd device/emulator as a
      different id to see it go to 2, if you want to confirm)
- [ ] **Messages** count increments as you send/receive
- [ ] Note the trial caps you're working within: **1,000 MAU / 20 PCC**

> Backgrounding the app / leaving chat should let PCC drop (disconnect on
> leave). Worth eyeballing that PCC doesn't stay pinned after you close.

---

## 7. Cleanup

- [ ] **Revert** `initialLocation` back to `'/'` in `app_router.dart`
- [ ] (Optional) delete the test channel + users `me` / `asha` from the
      dashboard so they don't skew usage counts
- [ ] Stop `flutter run`

---

## 8. What to report back

Share screenshots of:
- [ ] **Dashboard → Overview** (MAU / PCC / messages after the test)
- [ ] **Dashboard → the channel** message list
- [ ] The **app conversation** after 5.2–5.5

…and note any of: double-shown messages, auth errors in the console, missing
real-time delivery, status not transitioning, or history not loading. I'll
triage and fix before we open the PR.

---

## Out of scope for this test (tracked follow-ups, don't test)

- Push notifications (FCM config in Sendbird dashboard)
- Session-token auth (needs the BFF endpoint — depends on GCP #40)
- Block / Report (`reportUser` is stubbed; block works)
- Virtual Date **video** (separate WebRTC epic; the invite *card* is UI-only)
- Wiring `meId` to the real Firebase UID (currently hardcoded `me`)
