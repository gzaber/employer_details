import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/details_overview/details_overview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  group('DetailsOverviewCubit', () {
    late DetailsRepository mockDetailsRepository;

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

    DetailsOverviewCubit createCubit() =>
        DetailsOverviewCubit(detailsRepository: mockDetailsRepository);

    setUp(() {
      mockDetailsRepository = MockDetailsRepository();
    });

    test('constructor works properly', () {
      expect(() => createCubit(), returnsNormally);
    });

    test('initial state is correct', () {
      expect(
        createCubit().state,
        equals(const DetailsOverviewState()),
      );
    });

    group('getDetails', () {
      blocTest<DetailsOverviewCubit, DetailsOverviewState>(
          'emits state with success status and list of details when read successfully',
          setUp: () {
            when(() => mockDetailsRepository.readAllDetails())
                .thenAnswer((_) async => details);
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetails(),
          expect: () => [
                const DetailsOverviewState(),
                DetailsOverviewState(
                    status: DetailsOverviewStatus.success, details: details),
              ],
          verify: (_) {
            verify(() => mockDetailsRepository.readAllDetails()).called(1);
          });

      blocTest<DetailsOverviewCubit, DetailsOverviewState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => mockDetailsRepository.readAllDetails())
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetails(),
          expect: () => const [
                DetailsOverviewState(),
                DetailsOverviewState(status: DetailsOverviewStatus.failure),
              ],
          verify: (_) {
            verify(() => mockDetailsRepository.readAllDetails()).called(1);
          });
    });
  });
}
