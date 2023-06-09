import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/edit_mode/edit_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

void main() {
  group('EditModeCubit', () {
    late DetailsRepository detailsRepository;

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

    EditModeCubit createCubit() =>
        EditModeCubit(detailsRepository: detailsRepository);

    setUp(() {
      detailsRepository = MockDetailsRepository();
    });

    test('constructor works properly', () {
      expect(() => createCubit(), returnsNormally);
    });

    test('initial state is correct', () {
      expect(
        createCubit().state,
        equals(const EditModeState()),
      );
    });

    group('getDetails', () {
      blocTest<EditModeCubit, EditModeState>(
          'emits state with success status and list of details',
          setUp: () {
            when(() => detailsRepository.readAllDetails())
                .thenAnswer((_) async => details);
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetails(),
          expect: () => [
                const EditModeState(),
                EditModeState(status: EditModeStatus.success, details: details),
              ],
          verify: (_) {
            verify(() => detailsRepository.readAllDetails()).called(1);
          });

      blocTest<EditModeCubit, EditModeState>('emits state with failure status',
          setUp: () {
            when(() => detailsRepository.readAllDetails())
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetails(),
          expect: () => const [
                EditModeState(),
                EditModeState(status: EditModeStatus.failure),
              ],
          verify: (_) {
            verify(() => detailsRepository.readAllDetails()).called(1);
          });
    });

    group('deleteDetail', () {
      blocTest<EditModeCubit, EditModeState>(
          'emits state with success status when deleted successfully',
          setUp: () {
            when(() => detailsRepository.deleteDetail(1))
                .thenAnswer((_) async {});
          },
          build: () => createCubit(),
          act: (cubit) => cubit.deleteDetail(id: 1),
          expect: () => const [
                EditModeState(),
                EditModeState(status: EditModeStatus.success),
              ],
          verify: (_) {
            verify(() => detailsRepository.deleteDetail(1)).called(1);
          });

      blocTest<EditModeCubit, EditModeState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.deleteDetail(1))
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          act: (cubit) => cubit.deleteDetail(id: 1),
          expect: () => const [
                EditModeState(),
                EditModeState(status: EditModeStatus.failure),
              ],
          verify: (_) {
            verify(() => detailsRepository.deleteDetail(1)).called(1);
          });
    });
  });
}
