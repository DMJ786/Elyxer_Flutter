/// Moments Repository (Moments Module).
///
/// Serves the moments feed and records the current user's posts. The mock
/// fabricates a feed of own + others' moments; a BFF-backed impl slots in later
/// behind the same interface.
library;

import 'dart:typed_data';

import '../models/discovery_models.dart';
import '../models/moment_models.dart';

abstract class MomentsRepository {
  Future<List<Moment>> feed();

  /// Post a new moment (prepended to the feed). Returns it.
  Future<Moment> share({
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  });

  /// Edit one of the current user's moments.
  Future<void> edit(
    String id, {
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  });

  /// Delete one of the current user's moments.
  Future<void> delete(String id);
}

class MockMomentsRepository implements MomentsRepository {
  MockMomentsRepository() {
    _seed();
  }

  final List<Moment> _feed = <Moment>[];
  int _seq = 0;

  static String _img(String id) =>
      'https://images.unsplash.com/photo-$id?auto=format&fit=crop&w=800&q=80';

  static DiscoveryProfile _author(
    String id,
    String name,
    String photoId, {
    String occupation = '',
    String location = 'Mumbai',
    String myStory = '',
  }) {
    return DiscoveryProfile(
      id: id,
      name: name,
      age: 28,
      occupation: occupation,
      location: location,
      photos: <String>[_img(photoId)],
      myStory: myStory,
      about: const ProfileAbout(
        gender: '',
        pronouns: '',
        orientation: '',
        education: '',
        height: '',
      ),
    );
  }

  @override
  Future<List<Moment>> feed() async => List<Moment>.unmodifiable(_feed);

  @override
  Future<Moment> share({
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  }) async {
    final Moment moment = Moment(
      id: 'm_${_seq++}',
      author: _me,
      text: (text != null && text.trim().isNotEmpty) ? text.trim() : null,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      mood: mood,
      timeLabel: 'Just now',
      isMine: true,
    );
    _feed.insert(0, moment);
    return moment;
  }

  @override
  Future<void> edit(
    String id, {
    String? text,
    String? imageUrl,
    Uint8List? imageBytes,
    Mood? mood,
  }) async {
    final int i = _feed.indexWhere((m) => m.id == id);
    if (i == -1) return;
    _feed[i] = _feed[i].copyWith(
      text: text ?? _feed[i].text,
      imageUrl: imageUrl,
      imageBytes: imageBytes,
      mood: mood ?? _feed[i].mood,
    );
  }

  @override
  Future<void> delete(String id) async => _feed.removeWhere((m) => m.id == id);

  static final DiscoveryProfile _me =
      _author('me', 'You', '1517841905240-472988babdf9');

  void _seed() {
    final DiscoveryProfile maya = _author(
      'maya',
      'Maya',
      '1494790108377-be9c29b29330',
      occupation: 'Product Designer • UX Strategy',
      myStory:
          "I'm someone who brings the same focus to my personal life as I do "
          "my work. I value a balanced approach to everything.",
    );
    final DiscoveryProfile aarav = _author(
      'aarav',
      'Aarav',
      '1500648767791-00dcc994a43e',
      occupation: 'Software Architect',
      location: 'Bengaluru',
    );
    final DiscoveryProfile zoya = _author(
      'zoya',
      'Zoya',
      '1544005313-94ddf0286df2',
      occupation: 'Documentary Filmmaker',
      location: 'Delhi',
    );

    _feed.addAll(<Moment>[
      Moment(
        id: 'm_${_seq++}',
        author: _me,
        text:
            'Finding beauty in the quiet moments. Looking for someone who '
            'appreciates early morning coffee and late-night architecture talks.',
        mood: Mood.findingCalm,
        timeLabel: '2h ago',
        isMine: true,
      ),
      Moment(
        id: 'm_${_seq++}',
        author: _me,
        imageUrl: _img('1447933601403-0c6688de566e'),
        text: 'My first coffee love in Ooty!',
        mood: Mood.coffeeAndThoughts,
        timeLabel: '1d ago',
        isMine: true,
      ),
      Moment(
        id: 'm_${_seq++}',
        author: maya,
        text: 'Golden light, an old book, and nowhere to be. Bliss.',
        mood: Mood.goldenHour,
        timeLabel: '3h ago',
      ),
      Moment(
        id: 'm_${_seq++}',
        author: aarav,
        imageUrl: _img('1506905925346-21bda4d32df4'),
        text: 'Sunrise ride done. The city is quietest at 5am.',
        mood: Mood.littleJoys,
        timeLabel: '5h ago',
      ),
      Moment(
        id: 'm_${_seq++}',
        author: zoya,
        text: 'Chasing a story through the old lanes today. Rainy and perfect.',
        mood: Mood.rainyDayMood,
        timeLabel: '8h ago',
      ),
    ]);
  }
}
