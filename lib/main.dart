import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:barber_booking_app/services/constant.dart';
import 'package:barber_booking_app/services/app_theme.dart';
import 'package:barber_booking_app/pages/onboarding.dart';
import 'package:barber_booking_app/firebase_options.dart';
import 'package:get/get.dart';

// Shaqada ugu horreysa ee abka (Entry point).
// Halkan waa meesha uu barnaamijku ka bilaabmo (main function).
void main() async {
  // Hubi in xiriirka u dhexeeya Flutter iyo mashiinka hoose (engine) uu diyaar yahay ka hor inta aan la bilaabin code-ka async.
  WidgetsFlutterBinding.ensureInitialized();

  // Soo geli xogta sirta ah ee .env file-ka
  await dotenv.load(fileName: ".env");

  // Bilowga habka lacag bixinta ee Stripe adoo isticmaalaya furaha la bixiyay.
  Stripe.publishableKey = publishableKey;

  // Sug bilowga Firebase si abka uu ugu xirmo database-ka iyo adeegyada kale.
  // Options: DefaultFirebaseOptions.currentPlatform waxay si toos ah u doorataa habaynta saxda ah ee Android ama iOS.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Bilow orodka abka (MyApp).
  runApp(const MyApp());
}

// MyApp waa widget-ka saldhigga u ah barnaamijka oo dhan (Root Widget).
// Waa StatelessWidget sababtoo ah qaab dhismeedka sare ee abka ma isbeddelayo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Daminta astaanta yar ee 'debug' ee dhinaca midig ee sare.
      debugShowCheckedModeBanner: false,

      // Isticmaalka 'darkTheme' oo laga soo qaaday AppTheme si muuqaalka abka uu u noqdo mid madow (Dark Mode).
      theme: AppTheme.darkTheme,

      // Bogga ugu horreeya ee qofka u soo baxaya (Onboarding Screen).
      home: const Onboarding(),
    );
  }
}
