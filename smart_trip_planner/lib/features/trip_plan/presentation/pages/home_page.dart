import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBlocBloc, AuthBlocState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return Center(child: Text("hello ${state.user.name}"));
          }
          return Center(child: Text(""));
        },
      ),
    );
  }
}
