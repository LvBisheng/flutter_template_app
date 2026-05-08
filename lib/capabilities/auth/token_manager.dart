import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage.dart';

final tokenManagerProvider = Provider<TokenManager>(
  (_) => TokenManager(const SecureStorage()),
);

class TokenManager {
  TokenManager(this._storage);
  static const _key = 'access_token';
  final SecureStorage _storage;

  Future<void> saveToken(String token) => _storage.write(_key, token);
  Future<String?> readToken() => _storage.read(_key);
  Future<void> clearToken() => _storage.delete(_key);
}
