import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/utils/userdata.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlocBloc, AuthBlocState>(
      listenWhen: (previous, current) => current is AuthSuccess,
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<UserProvider>().setUserName(
            state.user.name,
            state.user.email,
          );
        }
      },
      child: child,
    );
  }
}
