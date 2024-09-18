import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:slagalica/features/auth/presentation/pages/auth_register_page.dart';
import 'package:slagalica/features/auth/presentation/pages/auth_sign_in_page.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/wrapped_text.dart';

class AuthSelectPage extends StatelessWidget {
  const AuthSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SLAGALICA",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontFamily: "Honey"),
            ),
            const SizedBox(height: 20),
            ButtonWithSize(
              text: "Registracija",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AuthRegisterPage(),
                  ),
                );
              },
            ),
            ButtonWithSize(
              text: "Prijava",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AuthSingInPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text("ili", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ButtonWithSize(
              text: "Igraj kao gost",
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            WrappedText(
              text: "Napomena: Igra kao gost neće sačuvati vaš napredak",
              textStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            WrappedText(
              text:
                  "Igranjem se slažete sa uslovima korišćenja i politikom privatnosti",
              textStyle: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }
}
