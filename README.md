# MAQAS - Professional Barber Booking App

MAQAS is a premium, state-of-the-art Flutter application designed for modern barber shops. It streamlines the appointment booking process, integrates secure payments, and provides a powerful admin dashboard for managing business operations.

---

## 🌟 Key Features

### For Users
- **Seamless Onboarding**: A beautiful introduction to the barber shop's services.
- **Secure Authentication**: Email and password-based login and registration via Firebase.
- **Dynamic Booking**: Select services, choose dates from the upcoming week, and pick available time slots.
- **Integrated Payments**: Secure checkout experience using Stripe API.
- **Booking History**: Keep track of upcoming and past appointments in real-time.
- **Profile Management**: Manage user details and account settings with ease.

### For Admins
- **Admin Dashboard**: A dedicated panel to view all incoming bookings.
- **Booking Management**: Mark appointments as completed with a single tap, syncing directly with Firestore.
- **Secure Access**: Manual admin credential verification for restricted access.

### For Developers
- **Somali Conceptual Comments**: The entire codebase (`lib` directory) features deep conceptual comments in **Somali (Afsomali)**, explaining core concepts like state management, Firebase streams, and Stripe integration. Perfect for Somali-speaking developers!

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (v3.x)
- **Backend/Database**: [Firebase Firestore](https://firebase.google.com/products/firestore)
- **Authentication**: [Firebase Auth](https://firebase.google.com/products/auth)
- **Payments**: [Stripe API](https://stripe.com/) via `flutter_stripe`
- **Environment Management**: `flutter_dotenv` for secure API key storage.
- **Local Storage**: `shared_preferences`
- **Design**: Vanilla CSS-inspired Material Design with a custom Dark Theme.

---

## 📁 Project Structure

```text
lib/
├── admin/          # Admin-specific logic and UI
├── pages/          # All user-facing screens and custom widgets
├── services/       # Auth, database, and local preference helpers
├── firebase_options.dart # Firebase configuration
└── main.dart       # App entry point and initialization
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
- A [Firebase Project](https://console.firebase.google.com/) setup with Firestore and Auth.
- A [Stripe Account](https://dashboard.stripe.com/) for API keys.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/barber_booking_app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd barber_booking_app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Configuration

1.  **Environment Variables**: The app uses `flutter_dotenv` for sensitive keys. Create a `.env` file in the root directory and add the following:
    ```env
    STRIPE_SECRET_KEY=your_secret_key
    STRIPE_PUBLISHABLE_KEY=your_publishable_key
    FIREBASE_API_KEY=your_firebase_api_key
    ```
    > [!IMPORTANT]
    > Never commit your `.env` file to version control. It is already added to `.gitignore`.

2.  **Firebase**: Replace `firebase_options.dart` with your own configuration or run `flutterfire configure`. The `apiKey` will be automatically pulled from environment variables once fully integrated.

### Running the App
```bash
flutter run
```

---

## 💇‍♂️ Modern Aesthetics
The app features a rich, dark-themed UI (Gunmetal & Copper) with smooth micro-animations, custom gradients, and responsive layouts to ensure a premium user experience.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
