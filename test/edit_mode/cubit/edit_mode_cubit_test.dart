import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/edit_mode/edit_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

class FakeDetail extends Fake implements Detail {}

void main() {
  group('EditModeCubit', () {
    late DetailsRepository detailsRepository;

    final detail1 = Detail(
        id: 1,
        title: 'title1',
        description: 'description1',
        iconData: 11111,
        position: 0);
    final detail2 = Detail(
        id: 2,
        title: 'title2',
        description: 'description2',
        iconData: 22222,
        position: 1);

    EditModeCubit createCubit() =>
        EditModeCubit(detailsRepository: detailsRepository);

    setUpAll(() {
      registerFallbackValue(FakeDetail());
    });

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
                .thenAnswer((_) async => [detail1, detail2]);
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetails(),
          expect: () => [
                const EditModeState(),
                EditModeState(
                  status: EditModeStatus.success,
                  details: [detail1, detail2],
                ),
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
          'emits state with success status and updated list of details when deleted successfully',
          setUp: () {
            when(() => detailsRepository.deleteDetail(1))
                .thenAnswer((_) async {});
            when(() => detailsRepository.updateDetail(any()))
                .thenAnswer((_) async {});
          },
          build: () => createCubit(),
          seed: () => EditModeState(
                status: EditModeStatus.success,
                details: [detail1, detail2],
              ),
          act: (cubit) => cubit.deleteDetail(id: detail1.id!),
          expect: () => [
                EditModeState(
                    status: EditModeStatus.loading,
                    details: [detail2.copyWith(position: 0)]),
                EditModeState(
                    status: EditModeStatus.success,
                    details: [detail2.copyWith(position: 0)]),
              ],
          verify: (_) {
            verify(() => detailsRepository.deleteDetail(1)).called(1);
            verify(() => detailsRepository
                .updateDetail(detail2.copyWith(position: 0))).called(1);
          });

      blocTest<EditModeCubit, EditModeState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.deleteDetail(1))
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          seed: () => EditModeState(
                status: EditModeStatus.success,
                details: [detail1, detail2],
              ),
          act: (cubit) => cubit.deleteDetail(id: 1),
          expect: () => [
                EditModeState(
                    status: EditModeStatus.loading,
                    details: [detail1, detail2]),
                EditModeState(
                    status: EditModeStatus.failure,
                    details: [detail1, detail2]),
              ],
          verify: (_) {
            verify(() => detailsRepository.deleteDetail(1)).called(1);
          });
    });

    group('deleteAllDetails', () {
      blocTest<EditModeCubit, EditModeState>(
          'emits state with success status and empty list of details when deleted successfully',
          setUp: () {
            when(() => detailsRepository.clearDetails())
                .thenAnswer((_) async {});
          },
          build: () => createCubit(),
          seed: () => EditModeState(
                status: EditModeStatus.success,
                details: [detail1, detail2],
              ),
          act: (cubit) => cubit.deleteAllDetails(),
          expect: () => [
                EditModeState(
                    status: EditModeStatus.loading,
                    details: [detail1, detail2]),
                const EditModeState(
                    status: EditModeStatus.success, details: []),
              ],
          verify: (_) {
            verify(() => detailsRepository.clearDetails()).called(1);
          });

      blocTest<EditModeCubit, EditModeState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.clearDetails()).thenThrow(Exception());
          },
          build: () => createCubit(),
          seed: () => EditModeState(
                status: EditModeStatus.success,
                details: [detail1, detail2],
              ),
          act: (cubit) => cubit.deleteAllDetails(),
          expect: () => [
                EditModeState(
                    status: EditModeStatus.loading,
                    details: [detail1, detail2]),
                EditModeState(
                    status: EditModeStatus.failure,
                    details: [detail1, detail2]),
              ],
          verify: (_) {
            verify(() => detailsRepository.clearDetails()).called(1);
          });
    });

    group('updateDetailPosition', () {
      blocTest<EditModeCubit, EditModeState>(
        'emits state with success status and updated list when old index is greater than new index',
        setUp: () {
          when(() => detailsRepository.updateDetail(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit(),
        seed: () => EditModeState(
          status: EditModeStatus.success,
          details: [detail1, detail2],
        ),
        act: (cubit) => cubit.updateDetailPosition(oldIndex: 1, newIndex: 0),
        expect: () => [
          EditModeState(status: EditModeStatus.loading, details: [
            detail2.copyWith(position: 0),
            detail1.copyWith(position: 1),
          ]),
          EditModeState(status: EditModeStatus.success, details: [
            detail2.copyWith(position: 0),
            detail1.copyWith(position: 1),
          ]),
        ],
        verify: (_) {
          verify(() =>
                  detailsRepository.updateDetail(detail1.copyWith(position: 1)))
              .called(1);
          verify(() =>
                  detailsRepository.updateDetail(detail2.copyWith(position: 0)))
              .called(1);
        },
      );

      blocTest<EditModeCubit, EditModeState>(
        'emits state with success status and updated list when old index is less than new index',
        setUp: () {
          when(() => detailsRepository.updateDetail(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit(),
        seed: () => EditModeState(
          status: EditModeStatus.success,
          details: [detail1, detail2],
        ),
        act: (cubit) => cubit.updateDetailPosition(oldIndex: 0, newIndex: 1),
        expect: () => [
          EditModeState(
              status: EditModeStatus.loading, details: [detail1, detail2]),
          EditModeState(
              status: EditModeStatus.success, details: [detail1, detail2]),
        ],
        verify: (_) {
          verify(() => detailsRepository.updateDetail(detail1)).called(1);
          verify(() => detailsRepository.updateDetail(detail2)).called(1);
        },
      );

      blocTest<EditModeCubit, EditModeState>(
        'emits state with failure status when failure occured',
        setUp: () {
          when(() => detailsRepository.updateDetail(any()))
              .thenThrow(Exception());
        },
        build: () => createCubit(),
        seed: () => EditModeState(
          status: EditModeStatus.success,
          details: [detail1, detail2],
        ),
        act: (cubit) => cubit.updateDetailPosition(oldIndex: 1, newIndex: 0),
        expect: () => [
          EditModeState(status: EditModeStatus.loading, details: [
            detail2.copyWith(position: 0),
            detail1.copyWith(position: 0),
          ]),
          EditModeState(status: EditModeStatus.failure, details: [
            detail2.copyWith(position: 0),
            detail1.copyWith(position: 0),
          ]),
        ],
        verify: (_) {
          verify(() =>
                  detailsRepository.updateDetail(detail2.copyWith(position: 0)))
              .called(1);
        },
      );
    });

    group('exportDetails', () {
      blocTest<EditModeCubit, EditModeState>(
        'emits state with success status and export confirmation when file saved successfully',
        setUp: () {
          when(() => detailsRepository.writeDetailsToFile(
              pathToFile: any(named: 'pathToFile'),
              details: any(named: 'details'))).thenAnswer((_) async {});
        },
        build: () => createCubit(),
        act: (cubit) => cubit.exportDetails(path: 'path', fileName: 'fileName'),
        seed: () => EditModeState(
          status: EditModeStatus.success,
          details: [detail1, detail2],
        ),
        expect: () => [
          EditModeState(
              status: EditModeStatus.loading, details: [detail1, detail2]),
          EditModeState(
              status: EditModeStatus.success,
              details: [detail1, detail2],
              isExported: true),
          EditModeState(
              status: EditModeStatus.success,
              details: [detail1, detail2],
              isExported: false),
        ],
        verify: (_) {
          verify(() => detailsRepository.writeDetailsToFile(
              pathToFile: 'path/fileName.json',
              details: [detail1, detail2])).called(1);
        },
      );

      blocTest<EditModeCubit, EditModeState>(
        'emits state with failure status when failure occured',
        setUp: () {
          when(() => detailsRepository.writeDetailsToFile(
              pathToFile: any(named: 'pathToFile'),
              details: any(named: 'details'))).thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.exportDetails(path: 'path', fileName: 'fileName'),
        seed: () => EditModeState(
          status: EditModeStatus.success,
          details: [detail1, detail2],
        ),
        expect: () => [
          EditModeState(
              status: EditModeStatus.loading, details: [detail1, detail2]),
          EditModeState(
              status: EditModeStatus.failure, details: [detail1, detail2]),
        ],
        verify: (_) {
          verify(() => detailsRepository.writeDetailsToFile(
              pathToFile: 'path/fileName.json',
              details: [detail1, detail2])).called(1);
        },
      );
    });

    group('importDetails', () {
      blocTest<EditModeCubit, EditModeState>(
        'emits state with success status and details when read file successfully',
        setUp: () {
          when(() => detailsRepository.readDetailsFromFile(
                  pathToFile: any(named: 'pathToFile')))
              .thenAnswer((_) async => [detail1, detail2]);
          when(() => detailsRepository.clearDetails()).thenAnswer((_) async {});
          when(() => detailsRepository.saveAllDetails(any()))
              .thenAnswer((_) async {});
        },
        build: () => createCubit(),
        act: (cubit) => cubit.importDetails(pathToFile: 'path/fileName.json'),
        seed: () =>
            const EditModeState(status: EditModeStatus.success, details: []),
        expect: () => [
          const EditModeState(status: EditModeStatus.loading, details: []),
          EditModeState(
              status: EditModeStatus.success, details: [detail1, detail2]),
        ],
        verify: (_) {
          verify(() => detailsRepository.readDetailsFromFile(
              pathToFile: 'path/fileName.json')).called(1);
          verify(() => detailsRepository.clearDetails()).called(1);
          verify(() => detailsRepository.saveAllDetails([detail1, detail2]))
              .called(1);
        },
      );

      blocTest<EditModeCubit, EditModeState>(
        'emits state with failure status when failure occured',
        setUp: () {
          when(() => detailsRepository.readDetailsFromFile(
              pathToFile: any(named: 'pathToFile'))).thenThrow(Exception());
        },
        build: () => createCubit(),
        act: (cubit) => cubit.importDetails(pathToFile: 'path/fileName.json'),
        seed: () =>
            const EditModeState(status: EditModeStatus.success, details: []),
        expect: () => const [
          EditModeState(status: EditModeStatus.loading),
          EditModeState(status: EditModeStatus.failure),
        ],
        verify: (_) {
          verify(() => detailsRepository.readDetailsFromFile(
              pathToFile: 'path/fileName.json')).called(1);
        },
      );
    });
  });
}
