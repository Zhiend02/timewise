import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Import Syncfusion Charts package

class IndividualPrint extends StatefulWidget {
  final String session;
  final DateTime startDate;
  final DateTime endDate;
  final String docId;
  final String selectedSubject;

  const IndividualPrint({
    Key? key,
    required this.session,
    required this.startDate,
    required this.endDate,
    required this.docId,
    required this.selectedSubject,
  }) : super(key: key);

  @override
  State<IndividualPrint> createState() => _IndividualPrintState();
}

class _IndividualPrintState extends State<IndividualPrint> {
  String? firstName;
  String? middleName;
  String? lastName;
  int numberOfDocuments = 0;
  int studentPresentCount = 0; // Variable to count presence of student
  bool showBarChart = true; // Flag to determine whether to show bar chart

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(
        widget.session == 'Odd' ? 'record_odd' : 'record_even',
      );

      String startDateString = DateFormat('yyyy-MM-dd').format(widget.startDate);
      String endDateString = DateFormat('yyyy-MM-dd').format(widget.endDate);

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collectionRef
          .where('date', isGreaterThanOrEqualTo: startDateString)
          .where('date', isLessThanOrEqualTo: endDateString)
          .get() as QuerySnapshot<Map<String, dynamic>>;

      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
      int count = 0;
      for (var document in documents) {
        if (document['subject'] == widget.selectedSubject) {
          count++;
          if (document['presentStudents'].contains(widget.docId)) {
            studentPresentCount++; // Increment if docId is present in presentStudent field
          }
        }
      }

      setState(() {
        numberOfDocuments = count;
      });

      // print('Number of Documents in Range for ${widget.selectedSubject}: $numberOfDocuments');
      // print('Student Present Count: $studentPresentCount'); // Print student present count

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(widget.docId).get();

      if (snapshot.exists) {
        setState(() {
          firstName = snapshot.get('firstName');
          middleName = snapshot.get('middleName');
          lastName = snapshot.get('lastName');
        });
      } else {
        // Handle case where the document doesn't exist
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error fetching data
    }
  }

  Widget _buildBarChart() {
    return Container(
      height: 100,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          BarSeries<Map<String, dynamic>, String>(
            dataSource: [
              {'category': 'Total Conducted', 'value': numberOfDocuments},
              {'category': 'Total Present', 'value': studentPresentCount},
            ],
            xValueMapper: (Map<String, dynamic> data, _) => data['category'],
            yValueMapper: (Map<String, dynamic> data, _) => data['value'],
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              labelPosition: ChartDataLabelPosition.outside,
            ), // Show data labels
          ),
        ],

      ),
    );
  }

  Widget _buildPieChart() {
    return SfCircularChart(
      series: <PieSeries>[
        PieSeries<Map<String, dynamic>, String>(
          dataSource: [
            {'category': 'Total Conducted', 'value': numberOfDocuments},
            {'category': 'Total Present', 'value': studentPresentCount},
          ],
          xValueMapper: (Map<String, dynamic> data, _) => data['category'],
          yValueMapper: (Map<String, dynamic> data, _) => data['value'],
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ), // Show data labels
        ),

      ],

    );

  }

  Widget _buildChart() {
    return showBarChart ? _buildBarChart() : _buildPieChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(9, 198, 249, 1),
                Color.fromRGBO(4, 93, 233, 1),
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Visualize'),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('Name: $firstName $middleName $lastName',style: const TextStyle(fontSize: 20,),),
                )),
            const SizedBox(height: 20),
            const Text('1.Total Lecture Present',style: const TextStyle(fontSize: 15,),),
            const Text('2.Total Lecture Conducted',style: const TextStyle(fontSize: 15,),),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: _buildChart(), // Widget to display the chart
              ),
            ),
            const SizedBox(height: 20),
            AnimatedButton(
              onPressed: () {
                setState(() {
                  showBarChart = !showBarChart; // Toggle between bar and pie chart
                });
              },
              text: (showBarChart ? 'Show Pie Chart' : 'Show Bar Chart'),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(9, 198, 249, 1),
                  Color.fromRGBO(4, 93, 233, 1),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
//almost pefect



class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final LinearGradient gradient;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: gradient,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}