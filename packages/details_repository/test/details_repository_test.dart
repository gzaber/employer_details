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
    late DetailsApi detailsApi;
    late DetailsRepository detailsRepository;
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
      detailsApi = MockDetailsApi();
      detailsRepository =
          DetailsRepository(detailsApi, fileSystem: mockFileSystem);

      when(() => mockFileSystem.file(any())).thenReturn(mockFile);
    });

    group('constructor', () {
      test('does not require FileSystem instance', () {
        expect(
          () => DetailsRepository(detailsApi),
          returnsNormally,
        );
      });

      test('works properly when FileSystem instance is provided', () {
        expect(
          () => DetailsRepository(detailsApi, fileSystem: mockFileSystem),
          returnsNormally,
        );
      });
    });

    group('saveDetail', () {
      test('saves Detail', () {
        when(() => detailsApi.saveDetail(any())).thenAnswer((_) async {});

        expect(detailsRepository.saveDetail(detail1), completes);
        verify(() => detailsApi.saveDetail(detail1)).called(1);
      });
    });

    group('saveAllDetails', () {
      test('saves list of Details', () {
        when(() => detailsApi.saveAllDetails(any())).thenAnswer((_) async {});

        expect(detailsRepository.saveAllDetails([detail1, detail2]), completes);
        verify(() => detailsApi.saveAllDetails([detail1, detail2])).called(1);
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

    group('clearDetails', () {
      test('clears all details in collection', () async {
        when(() => detailsApi.clearDetails()).thenAnswer((_) async {});

        expect(detailsRepository.clearDetails(), completes);
        verify(() => detailsApi.clearDetails()).called(1);
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
