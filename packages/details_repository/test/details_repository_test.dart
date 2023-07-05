import 'package:cross_file/cross_file.dart';
import 'package:details_api/details_api.dart';
import 'package:details_repository/details_repository.dart';
import 'package:file/file.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDetailsApi extends Mock implements DetailsApi {}

class FakeDetail extends Fake implements Detail {}

class MockFileSystem extends Mock implements FileSystem {}

class MockFile extends Mock implements File {}

void main() {
  group('DetailsRepository', () {
    late DetailsRepository detailsRepository;
    late DetailsApi mockDetailsApi;
    late FileSystem mockFileSystem;
    late File mockFile;

    final jsonDetailsString =
        '[{"id":1,"title":"title1","description":"description1","iconData":12345,"position":1}]';

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
      mockFileSystem = MockFileSystem();
      mockFile = MockFile();
      mockDetailsApi = MockDetailsApi();
      detailsRepository =
          DetailsRepository(mockDetailsApi, fileSystem: mockFileSystem);

      when(() => mockFileSystem.file(any())).thenReturn(mockFile);
    });

    group('constructor', () {
      test('does not require FileSystem instance', () {
        expect(
          () => DetailsRepository(mockDetailsApi),
          returnsNormally,
        );
      });

      test('works properly when FileSystem instance is provided', () {
        expect(
          () => DetailsRepository(mockDetailsApi, fileSystem: mockFileSystem),
          returnsNormally,
        );
      });
    });

    group('saveDetail', () {
      test('saves detail', () {
        when(() => mockDetailsApi.saveDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.saveDetail(detail1), completes);
        verify(() => mockDetailsApi.saveDetail(detail1)).called(1);
      });
    });

    group('saveAllDetails', () {
      test('saves list of details', () {
        when(() => mockDetailsApi.saveAllDetails(any()))
            .thenAnswer((_) async {});

        expect(detailsRepository.saveAllDetails([detail1, detail2]), completes);
        verify(() => mockDetailsApi.saveAllDetails([detail1, detail2]))
            .called(1);
      });
    });

    group('updateDetail', () {
      test('updates detail', () {
        when(() => mockDetailsApi.updateDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.updateDetail(detail1), completes);
        verify(() => mockDetailsApi.updateDetail(detail1)).called(1);
      });
    });

    group('deleteDetail', () {
      test('deletes detail', () {
        when(() => mockDetailsApi.deleteDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.deleteDetail(1), completes);
        verify(() => mockDetailsApi.deleteDetail(1)).called(1);
      });
    });

    group('readDetail', () {
      test('returns detail when it is found', () async {
        when(() => mockDetailsApi.readDetail(any()))
            .thenAnswer((_) async => detail1);

        expect(await detailsRepository.readDetail(1), equals(detail1));
        verify(() => mockDetailsApi.readDetail(1)).called(1);
      });

      test('returns null when detail is not found', () async {
        when(() => mockDetailsApi.readDetail(any()))
            .thenAnswer((_) async => null);

        expect(await detailsRepository.readDetail(1), isNull);
        verify(() => mockDetailsApi.readDetail(1)).called(1);
      });
    });

    group('readAllDetails', () {
      test('returns list of details', () async {
        when(() => mockDetailsApi.readAllDetails())
            .thenAnswer((_) async => [detail1, detail2]);

        expect(
          await detailsRepository.readAllDetails(),
          equals([detail1, detail2]),
        );
        verify(() => mockDetailsApi.readAllDetails()).called(1);
      });

      test('returns empty list when there are no details', () async {
        when(() => mockDetailsApi.readAllDetails()).thenAnswer((_) async => []);

        expect(await detailsRepository.readAllDetails(), isEmpty);
        verify(() => mockDetailsApi.readAllDetails()).called(1);
      });
    });

    group('clearDetails', () {
      test('clears all details in collection', () async {
        when(() => mockDetailsApi.clearDetails()).thenAnswer((_) async {});

        expect(detailsRepository.clearDetails(), completes);
        verify(() => mockDetailsApi.clearDetails()).called(1);
      });
    });

    group('writeDetailsToFile', () {
      test('writes details to file', () {
        when(() => mockFile.writeAsString(any()))
            .thenAnswer((_) async => mockFile);

        expect(
          detailsRepository
              .writeDetailsToFile(pathToFile: 'pathToFile', details: [detail1]),
          completes,
        );

        verify(() => mockFile.writeAsString(jsonDetailsString)).called(1);
      });
    });

    group('readDetailsFromFile', () {
      test('reads details from file', () async {
        when(() => mockFile.readAsString())
            .thenAnswer((_) async => jsonDetailsString);

        expect(
            await detailsRepository.readDetailsFromFile(
                pathToFile: 'pathToFile'),
            equals([detail1]));

        verify(() => mockFile.readAsString()).called(1);
      });
    });

    group('convertAllDetailsToXFile', () {
      test('converts details to XFile', () {
        expect(detailsRepository.convertAllDetailsToXFile([detail1]),
            isA<XFile>());
      });
    });
  });
}
