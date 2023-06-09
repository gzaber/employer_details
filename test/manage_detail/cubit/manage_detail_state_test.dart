import 'package:details_repository/details_repository.dart';
import 'package:employer_details/manage_detail/manage_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ManageDetailState', () {
    final detail = Detail(
        id: 1,
        title: 'title1',
        description: 'description1',
        iconData: 11111,
        position: 1);

    final defaultDetail = Detail(
      title: '',
      description: '',
      iconData: 58136,
      position: 0,
    );

    ManageDetailState createState() => ManageDetailState();

    test('constructor works properly', () {
      expect(() => createState(), returnsNormally);
    });

    test('supports value equality', () {
      expect(createState(), equals(createState()));
    });

    test('props are correct', () {
      expect(
        createState().props,
        [ManageDetailStatus.initial, defaultDetail],
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
          createState().copyWith(status: null, detail: null),
          equals(createState()),
        );
      });

      test('replaces non-null parameters', () {
        expect(
          createState()
              .copyWith(status: ManageDetailStatus.success, detail: detail),
          equals(
            ManageDetailState(
                status: ManageDetailStatus.success, detail: detail),
          ),
        );
      });
    });
  });
}
