import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_state.dart';
import 'package:slagalica/features/auth/presentation/widgets/circle_image_picker.dart';
import 'package:slagalica/features/main_menu/presentation/pages/main_menu_page.dart';
import 'package:slagalica/shared/services/validator/validator_service.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/form_input.dart';

class AuthRegisterPage extends StatelessWidget {
  AuthRegisterPage({super.key});
  AuthBloc authBloc = di<AuthBloc>();
  late AppStateBloc appStateBloc;

  @override
  Widget build(BuildContext context) {
    appStateBloc = BlocProvider.of<AppStateBloc>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocProvider<AuthBloc>(
        create: (_) => authBloc,
        child: _buildBody(context),
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
      title: const Text('Napravite profil'),
    );
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
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
                const CircleImagePicker(),
                const SizedBox(height: 40),
                FormInput(
                  hintText: "Korisnicko Ime",
                  onChanged: (value) {
                    authBloc.add(UsernameChangedEvent(value));
                  },
                  validator: (value) {
                    if (value.length > 40) {
                      return false;
                    }
                    return true;
                  },
                ),
                const SizedBox(height: 20),
                FormInput(
                  hintText: "Email",
                  errorText: "Email nije validan",
                  onChanged: (value) {
                    authBloc.add(EmailChangedEvent(value));
                  },
                  validator: (value) {
                    return di<ValidatorService>().isEmailValid(value);
                  },
                ),
                const SizedBox(height: 20),
                FormInput(
                  hintText: "Lozinka",
                  errorText: "Lozinka mora imati najmanje 8 karaktera",
                  onChanged: (value) {
                    authBloc.add(PasswordChangedEvent(value));
                  },
                  validator: (value) {
                    return di<ValidatorService>().isPasswordValid(value);
                  },
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                FormInput(
                  hintText: "Potvrdite lozinku",
                  errorText: "Lozinka mora imati najmanje 8 karaktera",
                  onChanged: (value) {
                    authBloc.add(ConfirmPasswordChangedEvent(value));
                  },
                  validator: (value) {
                    return di<ValidatorService>().isPasswordValid(value);
                  },
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: authBloc,
                  builder: (_, state) {
                    if (state is AuthStateRegister) {
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
                    if (state is AuthStateLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ButtonWithSize(
                      text: "Registracija",
                      onPressed: () {
                        List<String> deviceInfo = appStateBloc.getDeviceData();
                        authBloc.add(
                            AuthRegisterEvent(deviceInfo[0], deviceInfo[1]));
                      },
                      width: 0.8,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
