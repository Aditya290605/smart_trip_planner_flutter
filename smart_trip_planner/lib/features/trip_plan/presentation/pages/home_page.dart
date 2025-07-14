import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/constants/dummy_data.dart';
import 'package:smart_trip_planner/core/services/gemini_service.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
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
                          final res = await fetchItineraryFromLLM(
                            prompt: controller.text.trim(),
                          );
                          debugPrint("${res}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItineraryCreatedScreen(),
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

                      ListView.builder(
                        itemCount: title.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ItineriesCard(title: title[index]);
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
