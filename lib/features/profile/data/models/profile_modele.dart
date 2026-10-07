class ProfileModels {
  final int id;
  final String firstName;
  final String lastName;
  final String maidenName;
  final int age;
  final String gender;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String birthDate;
  final String image;
  final String bloodGroup;
  final double height;
  final double weight;
  final String eyeColor;
  final Hair hair;
  final String ip;
  final Address address;
  final String macAddress;
  final String university;
  final Bank bank;
  final Company company;
  final String ein;
  final String ssn;
  final String userAgent;
  final Crypto crypto;
  final String role;

  ProfileModels({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.birthDate,
    required this.image,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hair,
    required this.ip,
    required this.address,
    required this.macAddress,
    required this.university,
    required this.bank,
    required this.company,
    required this.ein,
    required this.ssn,
    required this.userAgent,
    required this.crypto,
    required this.role,
  });

  factory ProfileModels.fromJson(Map<String, dynamic> json) {
    return ProfileModels(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      maidenName: json['maidenName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'],
      username: json['username'],
      password: json['password'],
      birthDate: json['birthDate'],
      image: json['image'],
      bloodGroup: json['bloodGroup'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      eyeColor: json['eyeColor'],
      hair: Hair.fromJson(json['hair']),
      ip: json['ip'],
      address: Address.fromJson(json['address']),
      macAddress: json['macAddress'],
      university: json['university'],
      bank: Bank.fromJson(json['bank']),
      company: Company.fromJson(json['company']),
      ein: json['ein'],
      ssn: json['ssn'],
      userAgent: json['userAgent'],
      crypto: Crypto.fromJson(json['crypto']),
      role: json['role'],
    );
  }
}

class Hair {
  final String color;
  final String type;

  Hair({required this.color, required this.type});

  factory Hair.fromJson(Map<String, dynamic> json) =>
      Hair(color: json['color'], type: json['type']);
}

class Address {
  final String address;
  final String city;
  final String state;
  final String stateCode;
  final String postalCode;
  final Coordinates coordinates;
  final String country;

  Address({
    required this.address,
    required this.city,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.coordinates,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    address: json['address'],
    city: json['city'],
    state: json['state'],
    stateCode: json['stateCode'],
    postalCode: json['postalCode'],
    coordinates: Coordinates.fromJson(json['coordinates']),
    country: json['country'],
  );
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );
}

class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;
  final String iban;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.iban,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    cardExpire: json['cardExpire'],
    cardNumber: json['cardNumber'],
    cardType: json['cardType'],
    currency: json['currency'],
    iban: json['iban'],
  );
}

class Company {
  final String department;
  final String name;
  final String title;
  final Address address;

  Company({
    required this.department,
    required this.name,
    required this.title,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    department: json['department'],
    name: json['name'],
    title: json['title'],
    address: Address.fromJson(json['address']),
  );
}

class Crypto {
  final String coin;
  final String wallet;
  final String network;

  Crypto({required this.coin, required this.wallet, required this.network});

  factory Crypto.fromJson(Map<String, dynamic> json) => Crypto(
    coin: json['coin'],
    wallet: json['wallet'],
    network: json['network'],
  );
}
