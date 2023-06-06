import 'package:details_api/details_api.dart';
import 'package:test/test.dart';

class TestDetailsApi implements DetailsApi {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('DetailsApi', () {
    test('can be constructed', () {
      expect(TestDetailsApi.new, returnsNormally);
    });
  });
}
