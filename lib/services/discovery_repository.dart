/// Discovery Repository (Discovery Module).
///
/// The seam between the Discovery UI and its data source. `MockDiscoveryRepository`
/// serves seed profiles and records outgoing actions in memory so the whole
/// module runs with no backend. A future `BffDiscoveryRepository` will implement
/// the same interface against the AWS BFF (Aurora + Bedrock "Magic Search")
/// without the UI changing — the same vendor-agnostic pattern as ChatRepository.
library;

import '../models/discovery_models.dart';
import '../models/interest_models.dart';

/// Read + act on the browse deck.
abstract class DiscoveryRepository {
  /// The ordered deck of profiles to browse. (Later: ranked by the BFF.)
  Future<List<DiscoveryProfile>> loadDeck();

  /// React to a part of [profile] with a Vibe. Returns the recorded action.
  Future<SentVibe> sendVibe(
    DiscoveryProfile profile,
    VibeContext context, {
    String? joinMeForOption,
  });

  /// Propose a date idea to [profile]. Returns the recorded action.
  Future<SentInvite> sendInvite(
    DiscoveryProfile profile,
    InviteType type, {
    String? note,
  });

  /// Skip [profileId] — remove from the deck, no action recorded.
  Future<void> pass(String profileId);

  /// Block [profile] with a reason (+ optional free-text details).
  Future<void> block(
    DiscoveryProfile profile, {
    required BlockReason reason,
    String? details,
  });

  /// Report [profile] with a reason (+ optional free-text details).
  Future<void> report(
    DiscoveryProfile profile, {
    required ReportReason reason,
    String? details,
  });

  /// Vibes the current user has sent this session (source for the future
  /// Interests "Sent" tab).
  List<SentVibe> get sentVibes;

  /// Invites the current user has sent this session.
  List<SentInvite> get sentInvites;
}

/// In-memory implementation with seed data. No network, no delay.
class MockDiscoveryRepository implements DiscoveryRepository {
  final List<SentVibe> _sentVibes = <SentVibe>[];
  final List<SentInvite> _sentInvites = <SentInvite>[];
  final Set<String> _blocked = <String>{};
  final Set<String> _reported = <String>{};
  int _seq = 0;

  @override
  List<SentVibe> get sentVibes => List<SentVibe>.unmodifiable(_sentVibes);

  @override
  List<SentInvite> get sentInvites => List<SentInvite>.unmodifiable(_sentInvites);

  String _nextId(String prefix) => '${prefix}_${_seq++}';

  // Real portrait photos (Unsplash, cropped to portrait). These stand in for
  // the member's uploaded photos until the profile store is wired.
  static String _img(String id) =>
      'https://images.unsplash.com/photo-$id?auto=format&fit=crop&w=800&h=1040&q=80';

  @override
  Future<List<DiscoveryProfile>> loadDeck() async {
    return _seed
        .where((p) => !_blocked.contains(p.id) && !_reported.contains(p.id))
        .toList();
  }

  @override
  Future<SentVibe> sendVibe(
    DiscoveryProfile profile,
    VibeContext context, {
    String? joinMeForOption,
  }) async {
    final vibe = SentVibe(
      id: _nextId('vibe'),
      profileId: profile.id,
      profileName: profile.name,
      context: context,
      joinMeForOption: joinMeForOption,
      sentAt: DateTime.now(),
    );
    _sentVibes.add(vibe);
    return vibe;
  }

  @override
  Future<SentInvite> sendInvite(
    DiscoveryProfile profile,
    InviteType type, {
    String? note,
  }) async {
    final invite = SentInvite(
      id: _nextId('invite'),
      profileId: profile.id,
      profileName: profile.name,
      type: type,
      note: (note != null && note.trim().isNotEmpty) ? note.trim() : null,
      sentAt: DateTime.now(),
    );
    _sentInvites.add(invite);
    return invite;
  }

  @override
  Future<void> pass(String profileId) async {
    // No-op for the mock beyond deck advancement, which the notifier tracks.
  }

  @override
  Future<void> block(
    DiscoveryProfile profile, {
    required BlockReason reason,
    String? details,
  }) async {
    _blocked.add(profile.id);
  }

  @override
  Future<void> report(
    DiscoveryProfile profile, {
    required ReportReason reason,
    String? details,
  }) async {
    _reported.add(profile.id);
  }

  // ---- Seed profiles ------------------------------------------------------

  static final List<DiscoveryProfile> _seed = <DiscoveryProfile>[
    DiscoveryProfile(
      id: 'maya',
      name: 'Maya',
      age: 28,
      occupation: 'Product Designer • UX Strategy',
      location: 'Mumbai',
      photos: <String>[
        _img('1494790108377-be9c29b29330'),
        _img('1517841905240-472988babdf9'),
        _img('1524504388940-b1c1722653e1'),
        _img('1487412720507-e7ab37603c6f'),
        _img('1534528741775-53994a69daeb'),
      ],
      myStory:
          "I'm someone who brings the same focus to my personal life as I do "
          "my work. I value a balanced approach to everything, making sure "
          "there's always room for genuine connection and growth.",
      about: const ProfileAbout(
        gender: 'Woman',
        pronouns: 'She / Her',
        orientation: 'Straight',
        education: 'Doctorate/Phd',
        height: '5\'6"',
      ),
      languages: <String>['Malayalam', 'French', 'Hindi'],
      intents: <String>['Meaningful Connection', 'Shared Experience'],
      interests: <String>[
        'Deep curiosity',
        'Steady growth',
        'Nature',
        'Hiking',
        'Star gazing',
      ],
      narratives: <ProfileNarrative>[
        const ProfileNarrative(
          title: 'THE SILENT OBSERVER',
          content:
              'I find that staying grounded helps me tackle big challenges '
              'without losing sight of the small, joyful moments in between.',
        ),
        const ProfileNarrative(
          title: 'EYES FOR DETAIL',
          content:
              'Whether at my desk or out in the world, I try to lead with '
              'empathy and a really open mind.',
        ),
      ],
      joinMeFor: <String>[
        'A long evening walk',
        'Grabbing a quiet coffee',
        'Checking out local art',
      ],
    ),
    DiscoveryProfile(
      id: 'aarav',
      name: 'Aarav',
      age: 31,
      occupation: 'Software Architect • Fintech',
      location: 'Bengaluru',
      photos: <String>[
        _img('1500648767791-00dcc994a43e'),
        _img('1507003211169-0a1dd7228f2d'),
        _img('1506794778202-cad84cf45f1d'),
        _img('1531123897727-8f129e1688ce'),
      ],
      myStory:
          'Builder by trade, wanderer by weekend. I like conversations that '
          'go somewhere and plans that leave room for a detour.',
      about: const ProfileAbout(
        gender: 'Man',
        pronouns: 'He / Him',
        orientation: 'Straight',
        education: "Master's",
        height: '5\'11"',
      ),
      languages: <String>['Kannada', 'Hindi', 'English'],
      intents: <String>['Meaningful Connection', 'Something Long-term'],
      interests: <String>[
        'Cycling',
        'Specialty coffee',
        'Chess',
        'Live music',
      ],
      narratives: <ProfileNarrative>[
        const ProfileNarrative(
          title: 'WEEKEND CARTOGRAPHER',
          content:
              'Give me a map with a blank spot and I will find a reason to '
              'ride there before sunrise.',
        ),
      ],
      joinMeFor: <String>[
        'A sunrise cycle ride',
        'Trying a new filter coffee spot',
        'A quiet bookstore afternoon',
      ],
    ),
    DiscoveryProfile(
      id: 'zoya',
      name: 'Zoya',
      age: 26,
      occupation: 'Documentary Filmmaker',
      location: 'Delhi',
      photos: <String>[
        _img('1544005313-94ddf0286df2'),
        _img('1438761681033-6461ffad8d80'),
        _img('1502823403499-6ccfcf4fb453'),
      ],
      myStory:
          'I chase stories for a living, so I notice the little things. Warmth, '
          'curiosity and a good sense of humour go a long way with me.',
      about: const ProfileAbout(
        gender: 'Woman',
        pronouns: 'She / Her',
        orientation: 'Bisexual',
        education: "Bachelor's",
        height: '5\'4"',
      ),
      languages: <String>['Urdu', 'Hindi', 'English'],
      intents: <String>['Shared Experience', 'New Friendships'],
      interests: <String>[
        'Storytelling',
        'Street food',
        'Analog film',
        'Poetry',
      ],
      narratives: <ProfileNarrative>[
        const ProfileNarrative(
          title: 'FRAME BY FRAME',
          content:
              'The best stories are the ones people almost do not tell — I like '
              'making space for those.',
        ),
      ],
      joinMeFor: <String>[
        'A late-night chai run',
        'A film festival marathon',
        'Wandering an old part of the city',
      ],
    ),
  ];
}
