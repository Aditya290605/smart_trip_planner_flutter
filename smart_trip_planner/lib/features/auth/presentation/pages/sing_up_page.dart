import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:smart_trip_planner/features/auth/presentation/pages/login_page.dart';

import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_button.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_text_feild.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/google_singup_button.dart';
import 'package:smart_trip_planner/features/trip_plan/presentation/pages/home_page.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final route = MaterialPageRoute(builder: (context) => LogInPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBlocBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          }

          if (state is AuthFailure) {
            debugPrint(state.error);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.airplanemode_active_rounded,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Itinera AI",
                            style: Theme.of(context).textTheme.headlineMedium!
                                .copyWith(color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Create your Account",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Lets get started",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: AppColors.textLight),
                        ),
                      ),
                      const SizedBox(height: 40),

                      GoogleSingupButton(text: 'Sign up with google'),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Divider(color: AppColors.border)),
                          const SizedBox(width: 10),
                          Text(
                            "Or sign up with email",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.textLight),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 0),
                      Text(
                        "Name",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        hintText: 'Enter name',
                        prefixIcon: Icons.person,
                        controller: name,
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "Email",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        hintText: 'Enter email',
                        prefixIcon: Icons.email,
                        controller: email,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Password",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        hintText: 'Enter password',
                        prefixIcon: Icons.email,
                        controller: password,
                        isPassword: true,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Confrim password",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        hintText: 'Confrim password',
                        prefixIcon: Icons.email,
                        controller: confirmPassword,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, route);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have account ?",
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                TextSpan(
                                  text: " Sign In",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Sign up',
                        onPressed: () async {
                          debugPrint('buttons pressed');
                          if (formKey.currentState!.validate() &&
                              password.text.trim() ==
                                  confirmPassword.text.trim()) {
                            context.read<AuthBlocBloc>().add(
                              AuthSignUp(
                                email: email.text.trim(),
                                name: name.text.trim(),
                                password: password.text.trim(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("password not matched !")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
