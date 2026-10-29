import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final List<HomeQuickAction> quickActions;
  final List<HomeTemple> temples;
  final List<HomeCause> causes;
  final HomeAstrology? astrology;
  final List<HomePooja> poojas;
  final List<HomeActivity> upcomingActivities;
  final List<HomeRecommendation> recommendations;
  final List<HomeBanner> banners;
  final List<HomePandit> pandits;
  final List<HomeSupportItem> supportItems;

  const Home({
    this.quickActions = const [],
    this.temples = const [],
    this.causes = const [],
    this.astrology,
    this.poojas = const [],
    this.upcomingActivities = const [],
    this.recommendations = const [],
    this.banners = const [],
    this.pandits = const [],
    this.supportItems = const [],
  });

  @override
  List<Object?> get props => [
    quickActions,
    temples,
    causes,
    astrology,
    poojas,
    upcomingActivities,
    recommendations,
  ];
}

class HomeQuickAction extends Equatable {
  final String id;
  final String title;
  final String icon;

  const HomeQuickAction({
    required this.id,
    required this.title,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, icon];
}

class HomeTemple extends Equatable {
  final String id;
  final String name;
  final String image;
  final String location;

  const HomeTemple({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
  });

  @override
  List<Object?> get props => [id, name, image, location];
}

class HomeCause extends Equatable {
  final String id;
  final String title;
  final String image;
  final double? targetAmount;
  final double? collectedAmount;

  const HomeCause({
    required this.id,
    required this.title,
    required this.image,
    this.targetAmount,
    this.collectedAmount,
  });

  @override
  List<Object?> get props => [id, title, image, targetAmount, collectedAmount];
}

class HomeAstrology extends Equatable {
  final String title;
  final String subtitle;
  final String image;

  const HomeAstrology({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  List<Object?> get props => [title, subtitle, image];
}

class HomePooja extends Equatable {
  final String id;
  final String name;
  final String subName;
  final String image;
  final double price;

  const HomePooja({
    required this.id,
    required this.name,
    required this.subName,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name,subName, image, price];
}

class HomeActivity extends Equatable {
  final String id;
  final String title;
  final String date;
  final String image;

  const HomeActivity({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
  });

  @override
  List<Object?> get props => [id, title, date, image];
}

class HomeRecommendation extends Equatable {
  final String id;
  final String title;
  final String image;
  final String type;

  const HomeRecommendation({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, image, type];
}

class HomeBanner extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;

  const HomeBanner({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, price];
}

class HomePandit extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;

  const HomePandit({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, price];
}

class HomeSupportItem extends Equatable {
  final String id;
  final String name;
  final String image;
  final double price;

  const HomeSupportItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, image, price];
}
