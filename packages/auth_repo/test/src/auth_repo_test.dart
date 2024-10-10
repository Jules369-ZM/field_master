
import 'package:auth_repo/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:net_source/net_source.dart';

void main() {
  group('AuthRepo', () {
    test('can be instantiated', () {
      expect(AuthRepo.init(Config.empty()), isNotNull);
    });
  });
}
