import 'package:details_api/details_api.dart';
import 'package:test/test.dart';

void main() {
  group('Detail', () {
    Detail createDetail({
      int? id = 1,
      String title = 'title',
      String description = 'description',
      int iconData = 12345,
      int position = 1,
    }) =>
        Detail(
          id: id,
          title: title,
          description: description,
          iconData: iconData,
          position: position,
        );

    group('constructor', () {
      test('works properly', () {
        expect(() => createDetail(), returnsNormally);
      });
    });

    group('equality', () {
      test('supports value equality', () {
        expect(createDetail(), equals(createDetail()));
      });

      test('props are correct', () {
        expect(
          createDetail().props,
          equals([1, 'title', 'description', 12345, 1]),
        );
      });
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createDetail().copyWith(),
          equals(createDetail()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createDetail().copyWith(
            id: null,
            title: null,
            description: null,
            iconData: null,
            position: null,
          ),
          equals(createDetail()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createDetail().copyWith(
            id: 2,
            title: 'title2',
            description: 'description2',
            iconData: 54321,
            position: 9,
          ),
          createDetail(
            id: 2,
            title: 'title2',
            description: 'description2',
            iconData: 54321,
            position: 9,
          ),
        );
      });
    });
  });
}
