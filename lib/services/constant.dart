import 'package:flutter_dotenv/flutter_dotenv.dart';

// File-kan waxaa loogu talagalay in lagu keydiyo xogta aan isbeddelayn ee laga heli karo meel kasta (Global Constants).
// Concept: Waxaan halkan dhignay furayaasha Stripe (API Keys) si ay u fududaato in hal meel laga beddelo haddii loo baahdo.
String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';

String publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
