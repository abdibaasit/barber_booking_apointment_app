import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/pages/custom_button.dart';
import 'package:barber_booking_app/services/database.dart';
import 'package:barber_booking_app/services/shared_pref.dart';
import 'package:get/get.dart';
import 'package:barber_booking_app/controllers/main_controller.dart';
import 'package:barber_booking_app/pages/BottomNavigation.dart';
import 'package:barber_booking_app/services/constant.dart';

class DetailPage extends StatefulWidget {
  final List<String> services;
  final String totalPrice;
  const DetailPage({super.key, required this.services, required this.totalPrice});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? name, id;
  int? selectedDayIndex;
  int? selectedTimeIndex;
  DateTime? selectedDate;
  String? selectedTime;
  String amount = "0";

  // 'upcomingDays' waxay si toos ah u soo saartaa 7-da maalmood ee soo socda laga bilaabo maanta.
  // Concept: 'DateTime.now().add(Duration(days: index))' waxay noo suurtagelisaa inaan maalin kasta horay u socono (Dynamic List).
  List<DateTime> upcomingDays = List.generate(
    7,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  // 'timeSlots' waa liiska saacadaha shaqada ee timo-jaraha (Business Logic).
  List<String> timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    amount = widget.totalPrice;
  }

  // Shaqada lagu soo rido xogta SharedPreferences (Magaca iyo Id)
  void getSharedPrefs() async {
    final helper = sharedpreferenceHelper();
    name = await helper.getUserName();
    id = await helper.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isReady = selectedDayIndex != null && selectedTimeIndex != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Book Appointment"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildSectionTitle('Select Date'),
          const SizedBox(height: 15),
          _buildDaysList(),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                color: Color(
                  0xFF2C2D35,
                ), // Gunmetal Grey - distinct from main background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Time",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(child: _buildTimeSlotsGrid()),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Book Now - \$$amount",
                    onTap: () {
                      if (isReady && name != null && id != null) {
                        makePayment();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a day and time slot"),
                          ),
                        );
                      }
                    },
                    backgroundColor: isReady
                        ? AppColors.primary
                        : AppColors.background.withOpacity(0.5), // Disable look
                    textColor: isReady
                        ? AppColors.textBlack
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/barber.jpeg'),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.services.length == 1
                  ? widget.services.first
                  : '${widget.services.length} Services',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.services.length == 1
                  ? 'Professional Barber'
                  : widget.services.join(', '),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 18),
                SizedBox(width: 5),
                Text(
                  "4.8 (120 Reviews)",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDaysList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: upcomingDays.length,
        itemBuilder: (context, index) {
          DateTime date = upcomingDays[index];
          bool isSelected = selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDayIndex = index;
                selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 75,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppColors.textSecondary.withOpacity(0.2),
                      ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date), // Mon, Tue
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotsGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 2.5,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedTimeIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeIndex = index;
              selectedTime = timeSlots[index];
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : const Color(0xFF3A3B45), // Lighter Gunmetal for unselected
              borderRadius: BorderRadius.circular(12), // Rounded Rectangle
              border: Border.all(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                timeSlots[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 'makePayment' waa shaqada bilowga u ah barnaamijka lacag bixinta.
  // Concept: Waxay marka hore abuurtaa 'Payment Intent' (Codsi lacag bixin), ka dibna waxay soo bandhigtaa 'Payment Sheet' (Muuqaalka kaarka).
  Future<void> makePayment() async {
    try {
      // 1. Codso Stripe inuu kuu diyaariyo lacag bixinta.
      paymentIntent = await createPaymentIntent(amount, 'USD');

      // 2. Diyaari muuqaalka (Sheet) ay dadku kaarka ku qoranayaan.
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'MAQAS Barber Shop',
        ),
      );

      // 3. Marka wax walba diyaari yihiin, u muuji isticmaalaha.
      displayPaymentSheet();
    } catch (e) {
      // Qabo khaladaadka lacag bixinta
      print('Payment Error: $e');
    }
  }

  // 'displayPaymentSheet' waxay qabataa talaabada ugu dambeysa ee lacag bixinta iyo keydinta Firestore.
  Future<void> displayPaymentSheet() async {
    try {
      // Sug inta qofku uu ka dhammaystirayo qorista faahfaahinta kaarka.
      await Stripe.instance.presentPaymentSheet();

      // Concept: Haddii lacagtu marto (Success), waxaan diyaarinaynaa xogta (Map) lagu darayo Firestore.
      Map<String, dynamic> bookingInfo = {
        "Name": name,
        "Service": widget.services.join(', '),
        "Services": widget.services,
        "Amount": amount,
        "Id": id,
        "Date": DateFormat('EEEE, d MMM').format(selectedDate!),
        "Time": selectedTime,
      };

      // Keydi ballanta rasmiga ah ee Database-ka.
      await DatabaseService().addUserBooking(bookingInfo);

      if (!mounted) return;

      // U muuji isticmaalaha in shaqadii ay dhammaatay (Success Dialog).
      // U muuji isticmaalaha in shaqadii ay dhammaatay (Success Dialog).
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: AppColors.success, size: 50),
              SizedBox(height: 16),
              Text(
                "Booking Successful!",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your appointment has been booked.",
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  // Close dialog
                  Navigator.of(dialogContext).pop(); 
                  
                  // Navigate to Bookings tab (index 1)
                  Get.offAll(() => const CoolBottomNavigation(initialTab: 1));
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Payment Sheet Error: $e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      throw Exception(err);
    }
  }
}
