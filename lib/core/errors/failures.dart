abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends Failure {const NetworkFailure(super.message);}
class UnauthorizedFailure extends Failure {const UnauthorizedFailure(super.message);}
class ValidationFailure extends Failure {const ValidationFailure(super.message);}
class CacheFailure extends Failure {const CacheFailure(super.message);}
class UnknownFailure extends Failure {const UnknownFailure(super.message);}


