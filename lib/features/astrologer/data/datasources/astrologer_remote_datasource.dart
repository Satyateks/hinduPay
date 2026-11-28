import '../../../../core/widgets/app_img.dart';
import '../models/astrologer_model.dart';

abstract class AstrologerRemoteDataSource {
  Future<List<AstrologerModel>> getAstrologers({
    String? category,
    String? query,
  });

  Future<List<String>> getCategories();

  Future<AstrologerModel> getAstrologerById(String id);

  Future<bool> toggleFavorite(String astrologerId);
}

class AstrologerRemoteDataSourceImpl implements AstrologerRemoteDataSource {
  final Set<String> _favoriteIds = <String>{};

  static const List<String> _categories = [
    'All',
    'Numerology',
    'Nadi',
    'Vedic',
    'Prashana',
    'Palmistry',
    'Tarot',
  ];

  static final List<Map<String, dynamic>> _mockAstrologers = [
    {
      'id': 'sivaguru',
      'name': 'Sivaguru',
      'specialties': ['Tarot', 'Numerology'],
      'languages': ['English', 'Hindi'],
      'experience_years': 7,
      'rating': 4.9,
      'review_count': 16087,
      'original_rate_per_min': 30,
      'rate_per_min': 15,
      'image_url': AppImg.astrologerImg,
      'monthly_bookings': 1035,
      'bio_paragraphs': [
        'Sivaguru is a celebrity Tarot Card Reader. He completed his PhD and D.Sc in alternative therapies while running his healing centre simultaneously, and has appeared on leading news channels.',
        'He is a Tarot Card reader, Reiki grandmaster, Angel therapist, and Numerologist. He is a signature reader training people across the world through video conferencing as well.',
        'He has received recognition and awards from leading channels and organisations, runs his own NGO, and has conducted numerous stage shows, healing workshops, and award shows with celebrities.',
        'Clients consult him for relationship clarity, career direction, business growth, and practical spiritual remedies tailored to their birth chart and tarot spread.',
      ],
    },
    {
      'id': 'maishaa',
      'name': 'Maishaa',
      'specialties': ['Prashana', 'Tarot'],
      'languages': ['English', 'Hindi', 'Bengali'],
      'experience_years': 8,
      'rating': 4.8,
      'review_count': 21583,
      'original_rate_per_min': 25,
      'rate_per_min': 11,
      'image_url': AppImg.astrologer1Img,
      'monthly_bookings': 890,
      'bio_paragraphs': [
        'Maishaa is a renowned Prashana Kundali and Tarot practitioner with over 8 years of experience guiding individuals through pivotal life decisions.',
        'She specializes in accurate horary predictions, emotional healing, and marriage compatibility consultations in English, Hindi, and Bengali.',
        'Her compassionate and solution-oriented sessions focus on actionable remedies, mantra alignment, and clear timelines for career and family milestones.',
      ],
    },
    {
      'id': 'chajapathi',
      'name': 'Chajapathi',
      'specialties': ['Palmistry', 'Vedic'],
      'languages': ['English', 'Hindi'],
      'experience_years': 12,
      'rating': 4.4,
      'review_count': 19576,
      'original_rate_per_min': 20,
      'rate_per_min': 9,
      'image_url': AppImg.astrologer2Img,
      'monthly_bookings': 740,
      'bio_paragraphs': [
        'Acharya Chajapathi brings 12 years of traditional Vedic Astrology and Hasta Rekha (Palmistry) expertise rooted in classical texts.',
        'He analyzes planetary dashas, dosha remedies, and palm lines to deliver grounded guidance on finances, property, health, and ancestral rituals.',
        'Known for concise and authentic consultations, he helps seekers understand auspicious muhurat timings and simple Vedic remedies.',
      ],
    },
    {
      'id': 'shiv-k',
      'name': 'Shiv K',
      'specialties': ['Prashana', 'Tarot'],
      'languages': ['English', 'Hindi'],
      'experience_years': 4,
      'rating': 4.8,
      'review_count': 12087,
      'original_rate_per_min': 20,
      'rate_per_min': 9,
      'image_url': AppImg.astrologer3Img,
      'monthly_bookings': 620,
      'bio_paragraphs': [
        'Shiv K is an intuitive Tarot and Prashana consultant praised for his clarity and calm approach toward modern life challenges.',
        'Over 4 years of dedicated practice, he has helped thousands of clients navigate job transitions, higher education choices, and relationship questions.',
        'His readings combine classical tarot archetypes with immediate horary chart insights for practical next steps.',
      ],
    },
    {
      'id': 'prakhar',
      'name': 'Prakhar',
      'specialties': ['Nadi', 'Prashana'],
      'languages': ['English', 'Hindi', 'Bengali'],
      'experience_years': 12,
      'rating': 4.9,
      'review_count': 18976,
      'original_rate_per_min': 25,
      'rate_per_min': 13,
      'image_url': AppImg.astrologer4Img,
      'monthly_bookings': 950,
      'bio_paragraphs': [
        'Prakhar is a senior Nadi and Prashana astrologer with 12 years of experience decoding karmic patterns and planetary transits.',
        'Fluent in English, Hindi, and Bengali, he offers deep insights into career breakthroughs, foreign travel, and long-term prosperity.',
        'His clients value his precision with event timing and his straightforward, uplifting spiritual remedies.',
      ],
    },
    {
      'id': 'divishka',
      'name': 'Divishka',
      'specialties': ['Tarot', 'Prashana'],
      'languages': ['English', 'Hindi'],
      'experience_years': 10,
      'rating': 4.4,
      'review_count': 11954,
      'original_rate_per_min': 20,
      'rate_per_min': 11,
      'image_url': AppImg.astrologerImg,
      'monthly_bookings': 580,
      'bio_paragraphs': [
        'Divishka is an experienced Tarot reader and Prashana specialist with a decade of experience supporting seekers on love, career, and inner peace.',
        'She blends intuitive card spreads with gentle energy balancing practices to bring clarity during uncertain phases.',
        'Her consultations emphasize positivity, realistic timelines, and personalized daily spiritual habits.',
      ],
    },
  ];

  @override
  Future<List<AstrologerModel>> getAstrologers({
    String? category,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final normalizedCategory = category?.trim().toLowerCase();
    final normalizedQuery = query?.trim().toLowerCase() ?? '';

    return _mockAstrologers.where((raw) {
      final specialties = List<String>.from(raw['specialties'] ?? const []);
      final languages = List<String>.from(raw['languages'] ?? const []);
      final name = (raw['name']?.toString() ?? '').toLowerCase();

      final matchesCategory =
          normalizedCategory == null ||
          normalizedCategory.isEmpty ||
          normalizedCategory == 'all' ||
          specialties.any((s) => s.toLowerCase() == normalizedCategory);

      final matchesQuery =
          normalizedQuery.isEmpty ||
          name.contains(normalizedQuery) ||
          specialties.any((s) => s.toLowerCase().contains(normalizedQuery)) ||
          languages.any((l) => l.toLowerCase().contains(normalizedQuery));

      return matchesCategory && matchesQuery;
    }).map(_toModelWithFavorite).toList();
  }

  @override
  Future<List<String>> getCategories() async => List<String>.from(_categories);

  @override
  Future<AstrologerModel> getAstrologerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final match = _mockAstrologers.firstWhere(
      (item) => item['id'] == id,
      orElse: () => throw Exception('Astrologer not found'),
    );
    return _toModelWithFavorite(match);
  }

  @override
  Future<bool> toggleFavorite(String astrologerId) async {
    if (_favoriteIds.contains(astrologerId)) {
      _favoriteIds.remove(astrologerId);
      return false;
    }
    _favoriteIds.add(astrologerId);
    return true;
  }

  AstrologerModel _toModelWithFavorite(Map<String, dynamic> raw) {
    final id = raw['id']?.toString() ?? '';
    return AstrologerModel.fromJson({
      ...raw,
      'is_favorite': _favoriteIds.contains(id),
    });
  }
}

