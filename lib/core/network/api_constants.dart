class ApiConstants {
  ApiConstants._();

  // ----------------------------------------------------------
  // Base URL
  // ----------------------------------------------------------

  static const String baseUrl = 'https://api.yourdomain.com/api/v1';

  // Development example:
  // static const String baseUrl = 'https://dev-api.yourdomain.com/api/v1';

  // ----------------------------------------------------------
  // Timeout
  // ----------------------------------------------------------

  static const Duration connectTimeout = Duration(seconds: 30);

  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Duration sendTimeout = Duration(seconds: 30);

  // ----------------------------------------------------------
  // Auth
  // ----------------------------------------------------------

  static const String loginUrl = 'https://dummyjson.com/auth/login';//'/auth/login';

  static const String verifyOtpUrl = '/auth/verify-otp';

  static const String refreshTokenUrl = '/auth/refresh-token';

  static const String logoutUrl = '/auth/logout';

  static const String profileUrlUrl = 'https://dummyjson.com/users/1';

  // ----------------------------------------------------------
  // Pooja
  // ----------------------------------------------------------

  static const String poojas = '/poojas';

  // ----------------------------------------------------------
  // Products
  // ----------------------------------------------------------

  static const String products = '/products';

  static const String categories = '/categories';

  // ----------------------------------------------------------
  // Orders
  // ----------------------------------------------------------

  static const String orders = '/orders';

  // ----------------------------------------------------------
  // Payments
  // ----------------------------------------------------------

  static const String payments = '/payments';

  // ----------------------------------------------------------
  // Temples
  // ----------------------------------------------------------

  static const String temples = '/temples';

  // ----------------------------------------------------------
  // Darshan
  // ----------------------------------------------------------

  static const String darshan = '/darshan';

  // ----------------------------------------------------------
  // Pandit
  // ----------------------------------------------------------

  static const String pandits = '/pandits';

  // ----------------------------------------------------------
  // Donation
  // ----------------------------------------------------------

  static const String donations = '/donations';
}
