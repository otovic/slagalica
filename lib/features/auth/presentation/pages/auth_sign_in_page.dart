import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_state.dart';
import 'package:slagalica/features/main_menu/presentation/pages/main_menu_page.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/form_input.dart';

class AuthSingInPage extends StatelessWidget {
  AuthSingInPage({super.key});
  final AuthBloc authBloc = di<AuthBloc>();
  final AppStateBloc appStateBloc = di<AppStateBloc>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (_, state) {
          return _buildBody(context);
        },
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text("Prijava na profil"),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: SingleChildScrollView(
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
              FormInput(
                hintText: "Email",
                onChanged: (email) {
                  emailController.text = email;
                },
              ),
              const SizedBox(height: 20),
              FormInput(
                hintText: "Lozinka",
                isPassword: true,
                onChanged: (password) {
                  passwordController.text = password;
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder(
                bloc: authBloc,
                builder: (_, state) {
                  if (state is AuthStateLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is AuthStateSignedIn) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => MainMenuPage(),
                        ),
                        (route) => false,
                      );
                    });
                  }
                  if (state is AuthStateError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      appStateBloc.add(ShowSnackBarEvent(
                          context: context, message: state.message));
                    });
                  }

                  return ButtonWithSize(
                    text: "Prijavi se",
                    onPressed: () {
                      authBloc.add(SignInEvent(
                          emailController.text, passwordController.text));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
