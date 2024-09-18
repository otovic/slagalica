import 'package:flutter/material.dart';
import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/app_state_init/domain/entities/app_state_entity.dart';
import 'package:slagalica/features/app_state_init/domain/repository/app_state_repository.dart';

class AppStateInitUseCase
    implements UseCaseWithParams<AppStateEntity, BuildContext> {
  final AppStateRepository _repository;

  AppStateInitUseCase(this._repository);

  @override
  Future<AppStateEntity> call(BuildContext params) async {
    return await _repository.init(params);
  }
}
