abstract class BuyCoinsState {
  final int option;
  BuyCoinsState(this.option);
}

class BuyCoinsInitial extends BuyCoinsState {
  BuyCoinsInitial(int option) : super(option);
}

class PendingPurchaseState extends BuyCoinsState {
  PendingPurchaseState(int option) : super(option);
}

class PurchaseSuccessState extends BuyCoinsState {
  PurchaseSuccessState(int option) : super(option);
}

class PurchaseFailedState extends BuyCoinsState {
  PurchaseFailedState(int option) : super(option);
}
