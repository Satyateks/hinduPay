import '../models/pandit_model.dart';

abstract class PanditRemoteDataSource {
  Future<List<PanditModel>> getPandits(String? poojaFilter);
  Future<List<String>> getPoojaCategories();
  Future<bool> bookPandit({required String panditId, required String poojaName, required DateTime date});
}


class PanditRemoteDataSourceImpl implements PanditRemoteDataSource {
  final List<Map<String, dynamic>> _mockPandits = [
    {
      'id': '1',
      'name': 'Acharya Sharma',
      'specialization': 'Vedic Puja & Rudrabhishek',
      'image_url': '',
      'rating': 4.8,'location':'Noida',
      'supportedPoojas': ['Rudrabhishek', 'Satyanarayan Katha', 'Griha Pravesh']
    },
    {
      'id': '2',
      'name': 'Pandit Mishra',
      'specialization': 'Kundali & Maha Mrunjay Jaap',
      'image_url': '',
      'rating': 4.6,'location':'Noida',
      'supportedpoojas': ['Mahamrityunjay Jaap', 'Navgrah Shanti']
    },
    {
      'id': '3',
      'name': 'Shastri Ji',
      'specialization': 'Vivah Sanskar & Hawan',
      'image_url': '',
      'rating': 4.9,'location':'Noida',
      'supportedPoojas': ['Vivah', 'Griha Pravesh', 'Hawan']
    },
    {
      'id': '4',
      'name': 'Shastri Ji',
      'specialization': 'Vivah Sanskar & Hawan',
      'image_url': '',
      'rating': 4.9,'location':'Noida',
      'supportedPoojas': ['Vivah', 'Griha Pravesh', 'Hawan']
    },
  ];

  @override
  Future<List<PanditModel>> getPandits(String? poojaFilter) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (poojaFilter == null || poojaFilter.isEmpty || poojaFilter == 'All') {
      return _mockPandits.map((e) => PanditModel.fromJson(e)).toList();
    }

    // Pooja ke according filter karna
    final filtered = _mockPandits.where((p) {
      List poojas = p['supportedPoojas'] ?? [];
      return poojas.contains(poojaFilter);
    }).toList();

    return filtered.map((e) => PanditModel.fromJson(e)).toList();
  }

  @override
  Future<List<String>> getPoojaCategories() async {
    return ['All', 'Rudrabhishek', 'Satyanarayan Katha', 'Griha Pravesh', 'Mahamrityunjay Jaap', 'Hawan'];
  }

  @override
  Future<bool> bookPandit({required String panditId, required String poojaName, required DateTime date}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Success booking
  }
}