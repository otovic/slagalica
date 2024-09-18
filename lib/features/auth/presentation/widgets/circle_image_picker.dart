import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/auth/domain/entities/image_source.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_state.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/wrapped_text.dart';

class CircleImagePicker extends StatelessWidget {
  const CircleImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return Stack(
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          bloc: authBloc,
          buildWhen: (previous, current) =>
              previous.data.image != current.data.image,
          builder: (_, state) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.blueAccent.shade700,
                  width: 4,
                ),
              ),
              child: state.data.image == ''
                  ? ClipOval(
                      child: Image.asset(
                        'images/user.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
                        File(state.data.image!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              showPicker(context, BlocProvider.of<AuthBloc>(context));
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.shade700,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showPicker(BuildContext context, AuthBloc bloc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WrappedText(
                  text: "Izaberite sliku profila",
                  textStyle: Theme.of(context).textTheme.bodyMedium!),
              const SizedBox(height: 10),
              ButtonWithSize(text: "Kamera", onPressed: () {}),
              ButtonWithSize(
                text: "Galerija",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  bloc.add(AuthImagePickedEvent(source: EImageSource.gallery));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
