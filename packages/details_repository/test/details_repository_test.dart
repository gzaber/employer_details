import 'package:details_api/details_api.dart';
import 'package:details_repository/details_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDetailsApi extends Mock implements DetailsApi {}

class FakeDetail extends Fake implements Detail {}

void main() {
  group('DetailsRepository', () {
    late DetailsApi detailsApi;
    late DetailsRepository detailsRepository;

    final detail1 = Detail(
      id: 1,
      title: 'title1',
      description: 'description1',
      iconData: 12345,
      position: 1,
    );
    final detail2 = Detail(
      id: 2,
      title: 'title2',
      description: 'description2',
      iconData: 54321,
      position: 2,
    );

    setUpAll(() {
      registerFallbackValue(FakeDetail());
    });

    setUp(() {
      detailsApi = MockDetailsApi();
      detailsRepository = DetailsRepository(detailsApi);
    });

    group('constructor', () {
      test('works properly', () {
        expect(() => DetailsRepository(detailsApi), returnsNormally);
      });
    });

    group('createDetail', () {
      test('creates Detail', () {
        when(() => detailsApi.createDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.createDetail(detail1), completes);
        verify(() => detailsApi.createDetail(detail1)).called(1);
      });
    });

    group('updateDetail', () {
      test('updates Detail', () {
        when(() => detailsApi.updateDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.updateDetail(detail1), completes);
        verify(() => detailsApi.updateDetail(detail1)).called(1);
      });
    });

    group('deleteDetail', () {
      test('deletes Detail', () {
        when(() => detailsApi.deleteDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.deleteDetail(1), completes);
        verify(() => detailsApi.deleteDetail(1)).called(1);
      });
    });

    group('readDetail', () {
      test('returns Detail', () async {
        when(() => detailsApi.readDetail(any()))
            .thenAnswer((_) async => detail1);

        expect(await detailsRepository.readDetail(1), detail1);
        verify(() => detailsApi.readDetail(1)).called(1);
      });

      test('returns null if Detail doesn\'t exist', () async {
        when(() => detailsApi.readDetail(any())).thenAnswer((_) async => null);

        expect(await detailsRepository.readDetail(1), isNull);
        verify(() => detailsApi.readDetail(1)).called(1);
      });
    });

    group('readAllDetails', () {
      test('returns list of Details', () async {
        when(() => detailsApi.readAllDetails())
            .thenAnswer((_) async => [detail1, detail2]);

        expect(await detailsRepository.readAllDetails(), [detail1, detail2]);
        verify(() => detailsApi.readAllDetails()).called(1);
      });

      test('returns empty list if there are no Details', () async {
        when(() => detailsApi.readAllDetails()).thenAnswer((_) async => []);

        expect(await detailsRepository.readAllDetails(), isEmpty);
        verify(() => detailsApi.readAllDetails()).called(1);
      });
    });
  });
}
