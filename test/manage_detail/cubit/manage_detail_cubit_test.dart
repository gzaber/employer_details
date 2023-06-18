import 'package:bloc_test/bloc_test.dart';
import 'package:details_repository/details_repository.dart';
import 'package:employer_details/manage_detail/manage_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class MockDetailsRepository extends Mock implements DetailsRepository {}

class FakeDetail extends Fake implements Detail {}

void main() {
  group('ManageDetailCubit', () {
    late DetailsRepository detailsRepository;

    final detail = Detail(
        id: 1,
        title: 'title1',
        description: 'description1',
        iconData: 11111,
        position: 0);

    ManageDetailCubit createCubit() =>
        ManageDetailCubit(detailsRepository: detailsRepository);

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
        equals(ManageDetailState()),
      );
    });

    group('onIconChanged', () {
      blocTest<ManageDetailCubit, ManageDetailState>(
        'emits state with changed icon',
        build: () => createCubit(),
        seed: () => ManageDetailState(detail: detail),
        act: (cubit) => cubit.onIconChanged(54321),
        expect: () => [
          ManageDetailState(detail: detail.copyWith(iconData: 54321)),
        ],
      );
    });

    group('onTitleChanged', () {
      blocTest<ManageDetailCubit, ManageDetailState>(
        'emits state with changed title',
        build: () => createCubit(),
        seed: () => ManageDetailState(detail: detail),
        act: (cubit) => cubit.onTitleChanged('new title'),
        expect: () => [
          ManageDetailState(detail: detail.copyWith(title: 'new title')),
        ],
      );
    });

    group('onDescriptionChanged', () {
      blocTest<ManageDetailCubit, ManageDetailState>(
        'emits state with changed description',
        build: () => createCubit(),
        seed: () => ManageDetailState(detail: detail),
        act: (cubit) => cubit.onDescriptionChanged('new description'),
        expect: () => [
          ManageDetailState(
              detail: detail.copyWith(description: 'new description')),
        ],
      );
    });

    group('getDetail', () {
      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with success status and detail when successfully found',
          setUp: () {
            when(() => detailsRepository.readDetail(any()))
                .thenAnswer((_) async => detail);
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetail(detail.id),
          expect: () => [
                ManageDetailState(status: ManageDetailStatus.loading),
                ManageDetailState(
                    status: ManageDetailStatus.success, detail: detail),
              ],
          verify: (_) {
            verify(() => detailsRepository.readDetail(detail.id!)).called(1);
          });

      blocTest<ManageDetailCubit, ManageDetailState>(
          'doesn\'t emit any new state when id is null',
          build: () => createCubit(),
          act: (cubit) => cubit.getDetail(null),
          expect: () => [],
          verify: (_) {
            verifyNever(() => detailsRepository.readDetail(any()));
          });

      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.readDetail(any()))
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetail(detail.id),
          expect: () => [
                ManageDetailState(status: ManageDetailStatus.loading),
                ManageDetailState(status: ManageDetailStatus.failure),
              ],
          verify: (_) {
            verify(() => detailsRepository.readDetail(detail.id!)).called(1);
          });

      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with failure status when detail not found',
          setUp: () {
            when(() => detailsRepository.readDetail(any()))
                .thenAnswer((_) async => null);
          },
          build: () => createCubit(),
          act: (cubit) => cubit.getDetail(detail.id),
          expect: () => [
                ManageDetailState(status: ManageDetailStatus.loading),
                ManageDetailState(status: ManageDetailStatus.failure),
              ],
          verify: (_) {
            verify(() => detailsRepository.readDetail(detail.id!)).called(1);
          });
    });

    group('saveDetail', () {
      final newDetail = Detail(
          id: 2,
          title: 'title2',
          description: 'description2',
          iconData: 22222,
          position: 0);

      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with success status when detail saved successfully',
          setUp: () {
            when(() => detailsRepository.readAllDetails())
                .thenAnswer((_) async => [detail]);
            when(() => detailsRepository.saveDetail(any()))
                .thenAnswer((_) async {});
          },
          build: () => createCubit(),
          seed: () => ManageDetailState(detail: newDetail),
          act: (cubit) => cubit.saveDetail(),
          expect: () => [
                ManageDetailState(
                    status: ManageDetailStatus.loading, detail: newDetail),
                ManageDetailState(
                    status: ManageDetailStatus.saveSuccess, detail: newDetail),
              ],
          verify: (_) {
            verify(() => detailsRepository
                .saveDetail(newDetail.copyWith(position: 1))).called(1);
          });

      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.readAllDetails())
                .thenAnswer((_) async => [detail]);
            when(() => detailsRepository.saveDetail(any()))
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          seed: () => ManageDetailState(detail: newDetail),
          act: (cubit) => cubit.saveDetail(),
          expect: () => [
                ManageDetailState(
                    status: ManageDetailStatus.loading, detail: newDetail),
                ManageDetailState(
                    status: ManageDetailStatus.failure, detail: newDetail),
              ],
          verify: (_) {
            verify(() => detailsRepository
                .saveDetail(newDetail.copyWith(position: 1))).called(1);
          });
    });

    group('updateDetail', () {
      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with success status when detail updated successfully',
          setUp: () {
            when(() => detailsRepository.updateDetail(any()))
                .thenAnswer((_) async {});
          },
          build: () => createCubit(),
          seed: () => ManageDetailState(detail: detail),
          act: (cubit) => cubit.updateDetail(),
          expect: () => [
                ManageDetailState(
                    status: ManageDetailStatus.loading, detail: detail),
                ManageDetailState(
                    status: ManageDetailStatus.saveSuccess, detail: detail),
              ],
          verify: (_) {
            verify(() => detailsRepository.updateDetail(detail)).called(1);
          });

      blocTest<ManageDetailCubit, ManageDetailState>(
          'emits state with failure status when failure occured',
          setUp: () {
            when(() => detailsRepository.updateDetail(any()))
                .thenThrow(Exception());
          },
          build: () => createCubit(),
          seed: () => ManageDetailState(detail: detail),
          act: (cubit) => cubit.updateDetail(),
          expect: () => [
                ManageDetailState(
                    status: ManageDetailStatus.loading, detail: detail),
                ManageDetailState(
                    status: ManageDetailStatus.failure, detail: detail),
              ],
          verify: (_) {
            verify(() => detailsRepository.updateDetail(detail)).called(1);
          });
    });
  });
}
