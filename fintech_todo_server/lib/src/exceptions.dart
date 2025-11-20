import 'package:serverpod/serverpod.dart';

abstract class BaseAppException extends SerializableException {
  BaseAppException({this.message = 'An error occurred'});
  final String message;
}

class AuthorizationException extends BaseAppException {
  AuthorizationException({super.message = 'Unauthorized access'});
  String get name => 'AuthorizationException';
  int? get statusCode => 403;
}

class ValidationException extends BaseAppException {
  ValidationException({super.message = 'Validation failed'});
  String get name => 'ValidationException';
  int? get statusCode => 400;
}

class NotFoundException extends BaseAppException {
  NotFoundException({super.message = 'Resource not found'});
  String get name => 'NotFoundException';
  int? get statusCode => 404;
}
