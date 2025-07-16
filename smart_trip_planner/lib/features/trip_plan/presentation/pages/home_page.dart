import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/data/model/itinerary_hive_model.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/bloc/itinerary_event.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/profile_page.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/response_page.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/offline_saved_page.dart';
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
  bool _isOffline = false;
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectivityStream;
  bool _dialogShown = false;
  bool _firstBuild = true;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;
    _connectivity.checkConnectivity().then(_updateConnectionStatusFromList);
    _connectivityStream.listen(_updateConnectionStatusFromList);
  }

  void _updateConnectionStatusFromList(List<ConnectivityResult> results) {
    final isOffline =
        results.length == 1 && results.first == ConnectivityResult.none;
    if (mounted && isOffline != _isOffline) {
      setState(() {
        _isOffline = isOffline;
      });
    }
    // Always show dialog if offline and not already shown
    if (isOffline && !_dialogShown) {
      _dialogShown = true;
      _showNoInternetDialog();
    } else if (!isOffline) {
      _dialogShown = false;
    }
  }

  void _showNoInternetDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
              'You are offline. Some features may not work. You can still view offline itineraries.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _dialogShown = false;
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show dialog after first build if offline and not already shown
    if (_isOffline && !_dialogShown && _firstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_dialogShown && mounted) {
          _showNoInternetDialog();
        }
      });
      _firstBuild = false;
    }
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
                      if (_isOffline)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.wifi_off, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'No Internet Connection',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        onPressed: _isOffline
                            ? () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.wifi_off,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'You are offline. Creating itineraries is not available.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'You can still view offline itineraries.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                      ],
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : () async {
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
                                    builder: (context) =>
                                        ItineraryCreatedScreen(
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

                      PrimaryButton(
                        label: 'View All Offline Itineraries',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OfflineSavedPage(),
                            ),
                          );
                        },
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
