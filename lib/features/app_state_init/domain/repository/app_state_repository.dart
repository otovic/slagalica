import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/domain/entities/app_state_entity.dart';

abstract class AppStateRepository {
  Future<AppStateEntity> init(BuildContext context);
}
