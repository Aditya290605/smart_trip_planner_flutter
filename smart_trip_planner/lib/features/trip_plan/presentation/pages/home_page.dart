import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';

import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_hive_model.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/profile_page.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/response_page.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/itineries_card.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/primary_button.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/widgets/text_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

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
                child: SingleChildScrollView(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              child: Text(state.user.name.substring(0, 1)),
                            ),
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

                      InputTextBox(controller: controller),
                      const SizedBox(height: 30),

                      PrimaryButton(
                        label: 'Create My Itinerary',
                        onPressed: () async {
                          context.read<ItineraryBloc>().add(
                            GenerateItineraryEvent(
                              userInput: controller.text.trim(),
                              previousJson: '{}',
                              chatHistory: [],
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItineraryCreatedScreen(
                                initialPrompt: controller.text.trim(),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      Text(
                        'Offline Saved Itineraries',
                        style: Theme.of(context).textTheme.headlineMedium!,
                      ),

                      const SizedBox(height: 20),

                      ValueListenableBuilder(
                        valueListenable: Hive.box<ItineraryHiveModel>(
                          'itineraries',
                        ).listenable(),
                        builder: (context, Box<ItineraryHiveModel> box, _) {
                          final itineraries = box.values.toList();

                          if (itineraries.isEmpty) {
                            return const Center(
                              child: Text("No offline itineraries saved."),
                            );
                          }

                          return ListView.builder(
                            itemCount: itineraries.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final itinerary = itineraries[index];
                              return ItineriesCard(title: itinerary.title);
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
