
import 'package:flutter_test/flutter_test.dart';
import 'package:net_source/net_source.dart';
import 'package:services_repo/services_repo.dart';

void main() {
  group('ServicesRepo', () {
    test('can be instantiated', () {
      expect(ServicesRepo.init(Config.empty()), isNotNull);
    });
  });
}
