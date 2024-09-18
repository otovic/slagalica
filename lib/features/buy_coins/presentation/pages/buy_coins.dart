import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/make_purchase.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/process_purchase.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_bloc.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_event.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_state.dart';
import 'package:slagalica/features/buy_coins/presentation/widgets/buy_coins_option.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';

class BuyCoins extends StatelessWidget {
  BuyCoins({super.key});
  final AppStateBloc appStateBloc = di<AppStateBloc>();
  final BuyCoinsBloc buyCoinsBloc = BuyCoinsBloc(
      makePurchaseUseCase: di<MakePurchaseUseCase>(),
      processPurchaseUseCase: di<ProcessPurchaseUseCase>(),
      appStateBloc: di<AppStateBloc>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text('1.0.10'),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: SingleChildScrollView(
          child: BlocBuilder<BuyCoinsBloc, BuyCoinsState>(
            bloc: buyCoinsBloc,
            builder: (_, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Izaberi paket žetona',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  BuyCoinsOption(
                    ammount: "1",
                    price: "40",
                    description: "Jedna partija slagalice",
                    selected: state.option == 1,
                    onTap: () {
                      buyCoinsBloc.add(ChangeOptionEvent(1));
                    },
                  ),
                  BuyCoinsOption(
                    ammount: "8",
                    price: "280",
                    description: "8 partija slagalice",
                    selected: state.option == 2,
                    onTap: () {
                      buyCoinsBloc.add(ChangeOptionEvent(2));
                    },
                  ),
                  BuyCoinsOption(
                    ammount: "Neograničeno",
                    price: "4600",
                    description:
                        "Neograničen broj partija slagalice sledećih 28 dana",
                    selected: state.option == 3,
                    onTap: () {
                      buyCoinsBloc.add(ChangeOptionEvent(3));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _buildBottomAppBar(BuildContext context) {
    return BlocBuilder<BuyCoinsBloc, BuyCoinsState>(
      bloc: buyCoinsBloc,
      builder: (_, state) {
        if (state is PurchaseSuccessState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.pop(context);
            appStateBloc.add(PurchaseSuccessfullEvent(context));
          });
        } else if (state is PurchaseFailedState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            appStateBloc.add(PurchaseFailedEvent(context));
          });
        }

        return BottomAppBar(
          height: 100,
          color: Colors.blue,
          child: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(10),
            child: ButtonWithSize(
              text: 'Kupi žetone',
              isEnabled: state.option != 0,
              isLoading: state is PendingPurchaseState,
              onPressed: () {
                if (state != PendingPurchaseState) {
                  buyCoinsBloc.add(BuyEvent(context));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
