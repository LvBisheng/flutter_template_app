import '../domain/identity_update_repository.dart';
import 'identity_update_api.dart';

class IdentityUpdateRepositoryImpl implements IdentityUpdateRepository {
  const IdentityUpdateRepositoryImpl(this._api);
  final IdentityUpdateApi _api;

  @override
  Future<void> updateIdentity(Map<String, dynamic> payload) =>
      _api.update(payload);
}
