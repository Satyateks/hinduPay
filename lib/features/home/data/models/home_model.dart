import '../../domain/entities/home_data.dart';
import 'home_astrology_model.dart';
import 'home_cause_model.dart';
import 'home_pooja_model.dart';
import 'home_quick_action_model.dart';
import 'home_temple_model.dart';

class HomeModel extends Home {
  const HomeModel({
    super.quickActions,
    super.temples,
    super.causes,
    super.astrology,
    super.poojas,
    super.upcomingActivities,
    super.recommendations,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      quickActions: _parseList(
        json['quick_actions'],
        (item) => HomeQuickActionModel.fromJson(item as Map<String, dynamic>),
      ),
      temples: _parseList(
        json['temples'],
        (item) => HomeTempleModel.fromJson(item as Map<String, dynamic>),
      ),
      causes: _parseList(
        json['causes'],
        (item) => HomeCauseModel.fromJson(item as Map<String, dynamic>),
      ),
      astrology: json['astrology'] != null
          ? HomeAstrologyModel.fromJson(
              json['astrology'] as Map<String, dynamic>,
            )
          : null,
      poojas: _parseList(
        json['poojas'],
        (item) => HomePoojaModel.fromJson(item as Map<String, dynamic>),
      ),
      upcomingActivities: _parseList(
        json['upcoming_activities'],
        (item) => HomeActivityModel.fromJson(item as Map<String, dynamic>),
      ),
      recommendations: _parseList(
        json['recommendations'],
        (item) =>
            HomeRecommendationModel.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quick_actions': quickActions
          .map(
            (item) => {'id': item.id, 'title': item.title, 'icon': item.icon},
          )
          .toList(),

      'temples': temples
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'image': item.image,
              'location': item.location,
            },
          )
          .toList(),

      'causes': causes
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'image': item.image,
              'target_amount': item.targetAmount,
              'collected_amount': item.collectedAmount,
            },
          )
          .toList(),

      'astrology': astrology == null
          ? null
          : {
              'title': astrology!.title,
              'subtitle': astrology!.subtitle,
              'image': astrology!.image,
            },

      'poojas': poojas
          .map(
            (item) => {
              'id': item.id,
              'name': item.name,
              'image': item.image,
              'price': item.price,
            },
          )
          .toList(),

      'upcoming_activities': upcomingActivities
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'date': item.date,
              'image': item.image,
            },
          )
          .toList(),

      'recommendations': recommendations
          .map(
            (item) => {
              'id': item.id,
              'title': item.title,
              'image': item.image,
              'type': item.type,
            },
          )
          .toList(),
    };
  }

  static List<T> _parseList<T>(dynamic value, T Function(dynamic item) parser) {
    if (value is! List) {
      return [];
    }

    return value.map(parser).toList();
  }
}
