import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/data_sources/local/app_state_init_api_service.dart';
import 'package:slagalica/features/app_state_init/data/models/app_state_model.dart';
import 'package:slagalica/features/app_state_init/domain/repository/app_state_repository.dart';

class AppStateRepositoryImplementation implements AppStateRepository {
  final AppStateInitApiService _apiService;

  AppStateRepositoryImplementation(this._apiService);

  @override
  Future<AppStateModel> init(BuildContext context) async {
    return await _apiService.init(context);
  }
}
