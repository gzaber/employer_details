import 'package:details_repository/details_repository.dart';
import 'package:employer_details/details_overview/details_overview.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailsOverviewState', () {
    final details = [
      Detail(
          id: 1,
          title: 'title1',
          description: 'description1',
          iconData: 11111,
          position: 1),
      Detail(
          id: 2,
          title: 'title2',
          description: 'description2',
          iconData: 22222,
          position: 2),
    ];

    DetailsOverviewState createState() => const DetailsOverviewState();

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        [DetailsOverviewStatus.loading, []],
      );
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(
          createState().copyWith(),
          equals(createState()),
        );
      });

      test('retains old parameter value if null is provided', () {
        expect(
          createState().copyWith(status: null, details: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState().copyWith(
              status: DetailsOverviewStatus.success, details: details),
          equals(
            DetailsOverviewState(
                status: DetailsOverviewStatus.success, details: details),
          ),
        );
      });
    });
  });
}
