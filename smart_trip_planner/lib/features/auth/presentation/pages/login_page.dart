import 'package:flutter/material.dart';
import 'package:smart_trip_planner/core/theme/app_color.dart';
import 'package:smart_trip_planner/features/auth/presentation/pages/sing_up_page.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_button.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/custom_text_feild.dart';
import 'package:smart_trip_planner/features/auth/presentation/widgets/google_singup_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<LogInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final route = MaterialPageRoute(builder: (context) => SingUpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
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
                    "Hi welcome back !",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Login to your account",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: AppColors.textLight),
                  ),
                ),
                const SizedBox(height: 60),

                GoogleSingupButton(text: 'Sign in with google'),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    const SizedBox(width: 10),
                    Text(
                      "Or sign in with email",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 50),
                Text("Email", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomInputField(
                  hintText: 'Enter email',
                  prefixIcon: Icons.email,
                  controller: email,
                ),

                const SizedBox(height: 20),

                Text("Password", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomInputField(
                  hintText: 'Enter password',
                  prefixIcon: Icons.email,
                  controller: password,
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
                        text: "Dont have account ?",
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: " Create one",
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

                const SizedBox(height: 40),
                PrimaryButton(label: 'Sign In', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
