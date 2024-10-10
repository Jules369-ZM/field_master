import 'package:net_source/src/net_source.dart';
import 'package:test/test.dart';

void main() {
  group('NetSource', () {
    test('can be instantiated', () {
      expect(NetSource.init(baseUrl: '', host: '', socketUrl: ''), isNotNull);
    });
  });
}
