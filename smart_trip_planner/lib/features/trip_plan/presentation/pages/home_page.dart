import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/primary_button.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/text_box.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBlocBloc, AuthBlocState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hey ${state.user.name} 👋',
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(color: AppColors.primaryDark),
                        ),
                        CircleAvatar(
                          child: Text(state.user.name.substring(0, 1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "What’s your vision",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      "for this trip?",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 30),

                    InputTextBox(),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      label: 'Create My Itinerary',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
