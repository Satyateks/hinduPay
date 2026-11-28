import '../../domain/entities/pandit.dart';
import '../models/pandit_model.dart';

abstract class PanditRemoteDataSource {
  Future<List<PanditModel>> getPandits(String? poojaFilter);

  Future<List<PanditPoojaServiceModel>> getPoojaServices(String? poojaFilter);

  Future<List<String>> getPoojaCategories();

  Future<List<SamagriItemModel>> getSamagriCatalog();

  Future<List<SamagriItemModel>> getRecommendedSamagri();

  Future<PanditPoojaServiceModel> getPoojaServiceDetails(String serviceId);

  Future<bool> toggleSamagriFavorite(String itemId);

  Future<PanditBookingConfirmation> bookPandit({
    required String panditId,
    required String poojaName,
    required PanditDateOption date,
    required String timeSlot,
    required PanditServiceMode serviceMode,
    required PanditPaymentMode paymentMode,
    required PanditAddress address,
    required int totalPayable,
    required int totalSavings,
  });
}

class PanditRemoteDataSourceImpl implements PanditRemoteDataSource {
  final Set<String> _favoriteSamagriIds = <String>{};

  static const List<Map<String, dynamic>> _mockPandits = [
    {
      'id': '1',
      'name': 'Acharya Devendra Sharma',
      'specialization': 'Graha Shanti & Vedic Anushthan',
      'image_url': '',
      'rating': 4.8,
      'location': 'Greater Noida',
      'supported_poojas': [
        'Graha Shanti',
        'Rudrabhishek',
        'Satyanarayan Katha',
        'Griha Pravesh',
      ],
    },
    {
      'id': '2',
      'name': 'Pandit Raghavendra Mishra',
      'specialization': 'Saraswati Pooja & Kundali Remedies',
      'image_url': '',
      'rating': 4.8,
      'location': 'Greater Noida',
      'supported_poojas': ['Saraswati Pooja', 'Navgrah Shanti', 'Vastu Pooja'],
    },
    {
      'id': '3',
      'name': 'Acharya Vivek Shastri',
      'specialization': 'Mangal Dosh & Lakshmi Anushthan',
      'image_url': '',
      'rating': 4.7,
      'location': 'Noida NCR',
      'supported_poojas': ['Dosh Nivaran', 'Lakshmi Pooja', 'Hawan'],
    },
    {
      'id': '4',
      'name': 'Pandit Vishwanath Tiwari',
      'specialization': 'Griha Pravesh & Vivah Sanskar',
      'image_url': '',
      'rating': 4.9,
      'location': 'Delhi NCR',
      'supported_poojas': ['Griha Pravesh', 'Vivah', 'Hawan'],
    },
  ];

  static const List<Map<String, dynamic>> _mockPoojaServices = [
    {
      'id': 'rahu_ketu_shanti',
      'title': 'Rahu Ketu Graha Shanti Pooja',
      'category': 'Graha Shanti',
      'pandit_id': '1',
      'pandit_name': 'Acharya Devendra Sharma',
      'price': 2500,
      'original_price': 3100,
      'rating': 4.7,
      'review_count_label': '21k+',
      'visual_kind': 'rahu_ketu',
      'duration': '2 hrs',
      'description':
          'Complete Vedic Rahu-Ketu Graha Shanti vidhi with sankalp, mantra jaap, and hawan to harmonize planetary transitions.',
    },
    {
      'id': 'saraswati_career',
      'title': 'Saraswati Pooja for Career Growth',
      'category': 'Career & Vidya',
      'pandit_id': '2',
      'pandit_name': 'Pandit Raghavendra Mishra',
      'price': 2900,
      'original_price': 3700,
      'rating': 4.8,
      'review_count_label': '11k+',
      'visual_kind': 'saraswati',
      'duration': '90 mins',
      'description':
          'Auspicious Maa Saraswati pooja for focus, academic brilliance, creative clarity, and steady career advancement.',
    },
    {
      'id': 'mangal_dosh_nivaran',
      'title': 'Mangal Dosh Nivaran Pooja',
      'category': 'Dosh Nivaran',
      'pandit_id': '3',
      'pandit_name': 'Acharya Vivek Shastri',
      'price': 2100,
      'original_price': 2900,
      'rating': 4.7,
      'review_count_label': '17k+',
      'visual_kind': 'mangal_dosh',
      'duration': '90 mins',
      'description':
          'Traditional Mangal Dosh shanti and Navagraha ahuti performed with authentic Vedic chanting for harmony and peace.',
    },
    {
      'id': 'dhan_akarshan_lakshmi',
      'title': 'Dhan Akarshan Lakshmi Pooja',
      'category': 'Prosperity',
      'pandit_id': '3',
      'pandit_name': 'Acharya Vivek Shastri',
      'price': 5100,
      'original_price': 6500,
      'rating': 4.6,
      'review_count_label': '36k+',
      'visual_kind': 'lakshmi',
      'duration': '2.5 hrs',
      'description':
          'Sacred Shri Suktam & Mahalakshmi archana performed for abundance, business growth, and household prosperity.',
    },
    {
      'id': 'griha_pravesh_shanti',
      'title': 'Griha Pravesh Vastu Shanti Pooja',
      'category': 'Griha Pravesh',
      'pandit_id': '4',
      'pandit_name': 'Pandit Vishwanath Tiwari',
      'price': 4100,
      'original_price': 5200,
      'rating': 4.9,
      'review_count_label': '14k+',
      'visual_kind': 'griha_pravesh',
      'duration': '3 hrs',
      'description':
          'Vastu purush poojan, Kalash sthapana, and hawan to purify your new home with divine blessings.',
    },
    {
      'id': 'rudrabhishek_pooja',
      'title': 'Rudrabhishek Shiv Pooja',
      'category': 'Rudrabhishek',
      'pandit_id': '1',
      'pandit_name': 'Acharya Devendra Sharma',
      'price': 3100,
      'original_price': 4000,
      'rating': 4.8,
      'review_count_label': '19k+',
      'visual_kind': 'rudrabhishek',
      'duration': '2 hrs',
      'description':
          'Sacred Panchamrit Rudrabhishek of Lord Shiva with Rudrashtadhyayi path for health, protection, and serenity.',
    },
    {
      'id': 'satyanarayan_katha',
      'title': 'Satyanarayan Katha & Pooja',
      'category': 'Satyanarayan Katha',
      'pandit_id': '1',
      'pandit_name': 'Acharya Devendra Sharma',
      'price': 2100,
      'original_price': 2800,
      'rating': 4.8,
      'review_count_label': '24k+',
      'visual_kind': 'satyanarayan',
      'duration': '2 hrs',
      'description':
          'Auspicious family pooja and five-chapter Satyanarayan katha with prasad distribution and aarti.',
    },
    {
      'id': 'navgrah_shanti_hawan',
      'title': 'Navgrah Shanti Hawan Pooja',
      'category': 'Graha Shanti',
      'pandit_id': '2',
      'pandit_name': 'Pandit Raghavendra Mishra',
      'price': 3500,
      'original_price': 4500,
      'rating': 4.7,
      'review_count_label': '12k+',
      'visual_kind': 'navgrah',
      'duration': '2 hrs',
      'description':
          'Balanced nine-planet mantra ahuti and samagri hawan to bring peace and positive momentum.',
    },
  ];

  static const List<Map<String, dynamic>> _mockDefaultSamagri = [
    {
      'id': 'brass_daily_thali_set',
      'title': 'Brass Daily Pooja Thali Set',
      'variant': 'Medium',
      'price': 2999,
      'original_price': 3499,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'pooja_thali',
    },
    {
      'id': 'brass_ganesha_murti',
      'title': 'Brass Ganesha Ji Murti',
      'variant': 'Medium',
      'price': 2999,
      'original_price': 3499,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'ganesha_murti',
    },
  ];

  static const List<Map<String, dynamic>> _mockRecommendedSamagri = [
    {
      'id': 'brass_ganesha_murti',
      'title': 'Brass Ganesha Murti',
      'variant': 'Medium',
      'price': 2999,
      'original_price': 3499,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'ganesha_murti',
    },
    {
      'id': 'brass_pooja_thali_compact',
      'title': 'Brass Pooja Thali Set',
      'variant': 'Medium',
      'price': 1999,
      'original_price': 2299,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'pooja_thali_gold',
    },
    {
      'id': 'spiritual_rudraksha_bracelet',
      'title': 'Spiritual Rudraksha Bracelet',
      'variant': 'Standard',
      'price': 2500,
      'original_price': 3100,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'rudraksha_bracelet',
    },
    {
      'id': 'brass_daily_thali_set',
      'title': 'Brass Daily Pooja Thali Set',
      'variant': 'Medium',
      'price': 2999,
      'original_price': 3499,
      'rating': 4.9,
      'review_count_label': '16k+',
      'visual_kind': 'pooja_thali',
    },
  ];

  @override
  Future<List<PanditModel>> getPandits(String? poojaFilter) async {
    await Future.delayed(const Duration(milliseconds: 120));

    if (poojaFilter == null || poojaFilter.isEmpty || poojaFilter == 'All') {
      return _mockPandits.map(PanditModel.fromJson).toList();
    }

    final filtered = _mockPandits.where((p) {
      final poojas = List<String>.from(p['supported_poojas'] ?? const []);
      return poojas.contains(poojaFilter);
    }).toList();

    return filtered.map(PanditModel.fromJson).toList();
  }

  @override
  Future<List<PanditPoojaServiceModel>> getPoojaServices(
    String? poojaFilter,
  ) async {
    await Future.delayed(const Duration(milliseconds: 150));

    if (poojaFilter == null || poojaFilter.isEmpty || poojaFilter == 'All') {
      return _mockPoojaServices.map(PanditPoojaServiceModel.fromJson).toList();
    }

    final filtered = _mockPoojaServices
        .where((s) => s['category'] == poojaFilter)
        .map(PanditPoojaServiceModel.fromJson)
        .toList();
    return filtered;
  }

  @override
  Future<List<String>> getPoojaCategories() async {
    return const [
      'All',
      'Graha Shanti',
      'Career & Vidya',
      'Dosh Nivaran',
      'Prosperity',
      'Griha Pravesh',
      'Rudrabhishek',
      'Satyanarayan Katha',
    ];
  }

  @override
  Future<List<SamagriItemModel>> getSamagriCatalog() async {
    return _mockDefaultSamagri
        .map(
          (json) => SamagriItemModel.fromJson(
            json,
            isFavorite: _favoriteSamagriIds.contains(json['id']),
          ),
        )
        .toList();
  }

  @override
  Future<List<SamagriItemModel>> getRecommendedSamagri() async {
    return _mockRecommendedSamagri
        .map(
          (json) => SamagriItemModel.fromJson(
            json,
            isFavorite: _favoriteSamagriIds.contains(json['id']),
          ),
        )
        .toList();
  }

  @override
  Future<PanditPoojaServiceModel> getPoojaServiceDetails(
    String serviceId,
  ) async {
    final found = _mockPoojaServices.firstWhere(
      (item) => item['id'] == serviceId,
      orElse: () => _mockPoojaServices.first,
    );
    return PanditPoojaServiceModel.fromJson(found);
  }

  @override
  Future<bool> toggleSamagriFavorite(String itemId) async {
    if (_favoriteSamagriIds.contains(itemId)) {
      _favoriteSamagriIds.remove(itemId);
      return false;
    }
    _favoriteSamagriIds.add(itemId);
    return true;
  }

  @override
  Future<PanditBookingConfirmation> bookPandit({
    required String panditId,
    required String poojaName,
    required PanditDateOption date,
    required String timeSlot,
    required PanditServiceMode serviceMode,
    required PanditPaymentMode paymentMode,
    required PanditAddress address,
    required int totalPayable,
    required int totalSavings,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final panditMatch = _mockPandits.firstWhere(
      (p) => p['id'] == panditId,
      orElse: () => _mockPandits.first,
    );

    final bookingNumber =
        100000 + (DateTime.now().millisecondsSinceEpoch % 899999);

    return PanditBookingConfirmation(
      bookingId: 'PND-$bookingNumber',
      poojaTitle: poojaName,
      panditName: panditMatch['name']?.toString() ?? 'Acharya Devendra Sharma',
      date: date,
      timeSlot: timeSlot,
      serviceMode: serviceMode,
      paymentMode: paymentMode,
      address: address,
      totalPayable: totalPayable,
      totalSavings: totalSavings,
      createdAt: DateTime.now(),
    );
  }
}
