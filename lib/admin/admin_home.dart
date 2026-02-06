import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';

// AdminHome waa bogga maamulaha (Admin) ee uu ku arki karo dhammaan ballamaha (bookings).
// Waa StatefulWidget sababtoo ah waxaa jira xog isbeddelaysa oo u baahan in UI-ga dib loo dhisio.
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Shaqada 'completeBooking' waxay mas'uul ka tahay dhammaystirka ballanta.
  // Concept: Marka ballantu dhammaato, waxaan ka tirtirnaa Firestore (delete).
  // Tani waxay ka dhigan tahay in ballantii ay noqotay mid 'dhammaystiran' oo laga saaray liiska sugitaanka.
  Future<void> completeBooking(String id) async {
    // Tirtir dukumentiga gaarka ah ee uu ID-giisu yahay midka la soo gudbiyay.
    await FirebaseFirestore.instance.collection("Booking").doc(id).delete();

    // Muuji SnackBar si maamuluhu u ogaado in shaqadii ay guuleysatay.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking completed!"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "All Bookings",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [Expanded(child: allBookingsStream())]),
      ),
    );
  }

  // 'allBookingsStream' waa widget soo celinaya xogta Firestore si toos ah (Live data).
  Widget allBookingsStream() {
    // Concept: StreamBuilder wuxuu dhagaystaa (listen) isbeddellada Firestore.
    // Mar kasta oo qof cusub uu ballan qabsado ama mid la tirtiro, UI-gu si toos ah ayuu u cusboonaanayaa isagoo aan la refresh-gareyn.
    return StreamBuilder(
      // 'snapshots()' waxay bixiyaan xogta Firestore ee waqtiga dhabta ah (Real-time).
      stream: FirebaseFirestore.instance.collection("Booking").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Haddii xogtu ay weli soo socoto (loading), muuji goobada wareegaysa.
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Haddii 'docs' (dukumentiyada) ay faaruq yihiin, waxay ka dhigan tahay inaan wax ballan ah la hayn hadda.
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No bookings at the moment",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
            ),
          );
        }

        // ListView.builder waxaa loo isticmaalaa in lagu soo saaro liis weyn oo xog ah si hufan (Performance optimization).
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ds["Name"],
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => completeBooking(ds.id),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.5),
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ds["Service"],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ds["Date"],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.access_time_outlined,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ds["Time"],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
