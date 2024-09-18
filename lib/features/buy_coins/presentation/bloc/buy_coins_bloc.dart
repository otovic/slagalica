import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/buy_coins/data/models/in_app_purchase_model.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/make_purchase.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/process_purchase.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_event.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_state.dart';

class BuyCoinsBloc extends Bloc<BuyCoinsEvent, BuyCoinsState> {
  late StreamSubscription<List<PurchaseDetails>> subscription;
  final MakePurchaseUseCase makePurchaseUseCase;
  final ProcessPurchaseUseCase processPurchaseUseCase;
  final AppStateBloc appStateBloc;

  BuyCoinsBloc({
    required this.makePurchaseUseCase,
    required this.processPurchaseUseCase,
    required this.appStateBloc,
  }) : super(BuyCoinsInitial(0)) {
    on<ChangeOptionEvent>(_changeOption);
    on<BuyEvent>(_buy);
    on<PurchaseSuccessEvent>(_purchaseSuccess);
    on<PurchaseBCFailedEvent>(_purchaseFailedEvent);
    subscription = InAppPurchase.instance.purchaseStream.listen(
      (data) async {
        if (await processPurchaseUseCase(data)) {
          subscription.cancel();
          add(PurchaseSuccessEvent());
        } else {
          add(PurchaseBCFailedEvent());
        }
      },
      onDone: () {
        subscription.cancel();
      },
      onError: (error) {
        subscription.cancel();
      },
    );
  }

  _changeOption(ChangeOptionEvent event, Emitter<BuyCoinsState> emit) {
    emit(BuyCoinsInitial(event.option));
  }

  _purchaseSuccess(PurchaseSuccessEvent event, Emitter<BuyCoinsState> emit) {
    emit(PurchaseSuccessState(state.option));
  }

  _purchaseFailedEvent(
      PurchaseBCFailedEvent event, Emitter<BuyCoinsState> emit) {
    emit(PurchaseFailedState(state.option));
  }

  _buy(BuyEvent event, Emitter<BuyCoinsState> emit) async {
    try {
      emit(PendingPurchaseState(state.option));
      await makePurchaseUseCase(InAppPurchaseModel(state.option));
    } catch (e) {
      print("Error making a purchase: ${e}");
      emit(PurchaseFailedState(state.option));
    }
  }

  _getPurchaseID() {
    if (state.option == 1) {
      return 'single_token';
    } else if (state.option == 2) {
      return 'eight_tokens';
    } else if (state.option == 3) {
      return 'unlimited_tokens';
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
