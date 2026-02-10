import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barber_booking_app/services/colors.dart';
import 'package:barber_booking_app/services/database.dart';

class AdminBookings extends StatefulWidget {
  const AdminBookings({super.key});

  @override
  State<AdminBookings> createState() => _AdminBookingsState();
}

class _AdminBookingsState extends State<AdminBookings> {
  Stream? bookingStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  Future<void> getOnLoad() async {
    bookingStream = await DatabaseService().getAllBookings();
    setState(() {});
  }

  Future<void> markAsDone(String id) async {
    await DatabaseService().updateBookingStatus(id, "Done");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking Marked as Done!"),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        backgroundColor: AppColors.background,
        title: const Text(
          "All Bookings",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: StreamBuilder(
          stream: bookingStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No bookings found",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: AppColors.textSecondary.withOpacity(0.2),
                  ),
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      AppColors.primary.withOpacity(0.1),
                    ),
                    dataRowColor: MaterialStateProperty.all(AppColors.card),
                    columns: const [
                       DataColumn(label: Text('Customer', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Service', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Date', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Time', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Amount', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Status', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                       DataColumn(label: Text('Action', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                    ],
                    rows: _buildRows(snapshot.data.docs),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _buildRows(List<DocumentSnapshot> docs) {
    return docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String status = data['Status'] ?? 'Pending';
      bool isDone = status == 'Done';

      return DataRow(
        cells: [
          DataCell(Text(data['Name'] ?? '', style: const TextStyle(color: AppColors.textPrimary))),
          DataCell(Text(data['Service'] ?? '', style: const TextStyle(color: AppColors.textPrimary))),
          DataCell(Text(data['Date'] ?? '', style: const TextStyle(color: AppColors.textSecondary))),
          DataCell(Text(data['Time'] ?? '', style: const TextStyle(color: AppColors.textSecondary))),
          DataCell(Text("\$${data['Amount']}", style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold))),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDone ? AppColors.success.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isDone ? AppColors.success : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          DataCell(
            isDone
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : IconButton(
                    icon: const Icon(Icons.check, color: AppColors.primary),
                    onPressed: () => markAsDone(doc.id),
                  ),
          ),
        ],
      );
    }).toList();
  }
}
