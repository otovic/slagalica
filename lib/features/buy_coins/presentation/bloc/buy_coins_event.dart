import 'package:flutter/material.dart';

abstract class BuyCoinsEvent {
  BuyCoinsEvent();
}

class ChangeOptionEvent extends BuyCoinsEvent {
  final int option;
  ChangeOptionEvent(this.option) : super();
}

class PurchaseSuccessEvent extends BuyCoinsEvent {
  PurchaseSuccessEvent() : super();
}

class PurchaseBCFailedEvent extends BuyCoinsEvent {
  PurchaseBCFailedEvent() : super();
}

class BuyEvent extends BuyCoinsEvent {
  BuildContext context;
  BuyEvent(this.context) : super();
}
