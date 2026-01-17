import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure(this.message, [this.code]);
  
  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Sunucu hatası oluştu', super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'İnternet bağlantınızı kontrol edin']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Önbellek hatası']);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = 'Kimlik doğrulama hatası']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Kayıt bulunamadı']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Bu işlem için yetkiniz yok']);
}

class BannedFailure extends Failure {
  final DateTime? bannedUntil;
  
  const BannedFailure([
    super.message = 'Hesabınız yasaklanmış',
    this.bannedUntil,
  ]);
  
  @override
  List<Object?> get props => [message, bannedUntil];
}

class MutedFailure extends Failure {
  final DateTime? mutedUntil;
  
  const MutedFailure([
    super.message = 'Yorumlarınız geçici olarak kısıtlanmış',
    this.mutedUntil,
  ]);
  
  @override
  List<Object?> get props => [message, mutedUntil];
}

// Exceptions
class ServerException implements Exception {
  final String message;
  final int? code;
  
  ServerException([this.message = 'Server error', this.code]);
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException([this.message = 'Network error']);
}

class CacheException implements Exception {
  final String message;
  
  CacheException([this.message = 'Cache error']);
}

class AuthenticationException implements Exception {
  final String message;
  
  AuthenticationException([this.message = 'Authentication error']);
}