import 'package:isar_details_api/isar_details_api.dart';
import 'package:test/test.dart';

void main() {
  group('DetailModel', () {
    DetailModel createDetailModel() => DetailModel(
          id: 1,
          title: 'title',
          description: 'description',
          iconData: 12345,
          position: 2,
        );

    Detail createDetail() => Detail(
          id: 1,
          title: 'title',
          description: 'description',
          iconData: 12345,
          position: 2,
        );

    group('constructor', () {
      test('works properly', () {
        expect(() => createDetailModel(), returnsNormally);
      });
    });

    group('equality', () {
      test('supports value equality', () {
        expect(createDetailModel(), equals(createDetailModel()));
      });

      test('props are correct', () {
        expect(
          createDetailModel().props,
          equals([1, 'title', 'description', 12345, 2]),
        );
      });
    });

    group('fromDetail', () {
      test('returns DetailModel created from Detail', () {
        expect(
          DetailModel.fromDetail(createDetail()),
          createDetailModel(),
        );
      });
    });

    group('to Detail', () {
      test('returns Detail created from DetailModel', () {
        expect(
          createDetailModel().toDetail(),
          createDetail(),
        );
      });
    });
  });
}
