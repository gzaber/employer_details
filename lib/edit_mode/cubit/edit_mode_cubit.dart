import 'dart:convert';
import 'dart:math';

import 'package:details_repository/details_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_mode_state.dart';

class EditModeCubit extends Cubit<EditModeState> {
  EditModeCubit({
    required DetailsRepository detailsRepository,
    FileSystem? fileSystem,
  })  : _detailsRepository = detailsRepository,
        _fileSystem = fileSystem ?? const LocalFileSystem(),
        super(const EditModeState());

  final DetailsRepository _detailsRepository;
  final FileSystem _fileSystem;

  void getDetails() async {
    emit(state.copyWith(status: EditModeStatus.loading));
    try {
      final details = await _detailsRepository.readAllDetails();
      details.sort((a, b) => a.position.compareTo(b.position));
      emit(
        state.copyWith(
          status: EditModeStatus.success,
          details: details,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void deleteDetail({required int id}) async {
    emit(state.copyWith(status: EditModeStatus.loading));
    try {
      await _detailsRepository.deleteDetail(id);
      final details = state.details;
      final deletedIndex = details.indexWhere((d) => d.id == id);
      details.removeAt(deletedIndex);
      for (int i = deletedIndex; i < details.length; i++) {
        details[i] = details[i].copyWith(position: i);
        await _detailsRepository.updateDetail(details[i]);
      }
      emit(state.copyWith(status: EditModeStatus.success, details: details));
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void deleteAllDetails() async {
    emit(state.copyWith(status: EditModeStatus.loading));
    try {
      await _detailsRepository.clearDetails();
      emit(state.copyWith(status: EditModeStatus.success, details: []));
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void updateDetailPosition({
    required int oldIndex,
    required int newIndex,
  }) async {
    emit(state.copyWith(status: EditModeStatus.loading));
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final details = state.details;
    final detail = details.removeAt(oldIndex);
    details.insert(newIndex, detail);

    final minIndex = min(oldIndex, newIndex);
    try {
      for (int i = minIndex; i < details.length; i++) {
        details[i] = details[i].copyWith(position: i);
        await _detailsRepository.updateDetail(details[i]);
      }
      emit(
        state.copyWith(status: EditModeStatus.success, details: details),
      );
    } catch (_) {
      emit(state.copyWith(status: EditModeStatus.failure));
    }
  }

  void exportDetails({
    required String? path,
    required String fileName,
  }) async {
    if (path != null) {
      emit(state.copyWith(status: EditModeStatus.loading));
      try {
        final jsonDetails = state.details.map((d) => d.toJson()).toList();
        final jsonString = jsonEncode(jsonDetails);
        await _fileSystem
            .file('$path/$fileName.json')
            .writeAsString(jsonString);
        emit(state.copyWith(status: EditModeStatus.success, isExported: true));
        emit(state.copyWith(isExported: false));
      } catch (_) {
        emit(state.copyWith(status: EditModeStatus.failure));
      }
    }
  }

  void importDetails({required String? path}) async {
    if (path != null) {
      emit(state.copyWith(status: EditModeStatus.loading));
      try {
        final data = await _fileSystem.file(path).readAsString();
        final List<dynamic> jsonDetails = jsonDecode(data);
        final details = jsonDetails.map((d) => Detail.fromJson(d)).toList();
        await _detailsRepository.clearDetails();
        await _detailsRepository.saveAllDetails(details);
        emit(
          state.copyWith(status: EditModeStatus.success, details: details),
        );
      } catch (_) {
        emit(state.copyWith(status: EditModeStatus.failure));
      }
    }
  }
}
