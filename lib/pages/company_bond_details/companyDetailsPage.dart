import 'package:bonds/models/company_details_bond.dart';
import 'package:bonds/pages/company_bond_details/companyDetailsController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CompanyDetailsPage extends StatefulWidget {
  const CompanyDetailsPage({super.key});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  late Future<CompanyDetailModel> _futureCompanyDetails;
  int _selectedTabIndex = 0;
  bool _isAnimated = false;
  String selectedOption = "EBITDA";

  final List<double> randomData = List.generate(12, (index) => (index + 1) * 1.0); // Example data

  final CompanyDetailsController _controller = CompanyDetailsController();

  @override
  void initState() {
    super.initState();
    _futureCompanyDetails = _controller.fetchCompanyDetails();
    Future.delayed(const Duration(milliseconds: 1300), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: appBar(context),
      body: FutureBuilder<CompanyDetailModel>(
        future: _futureCompanyDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final company = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xffFFFFFF),
                              border: Border.all(
                                color: const Color(0xffE5E7EB),
                                width: 0.5,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            width: 60,
                            child: Image.network(company.logo!),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            company.companyName ?? '',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            company.description ?? 'No Description',
                            style: const TextStyle(color: Color(0xff6A7282), fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xff2563EB).withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  'ISIN: ${company.isin ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xff2563EB)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xff059669).withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  company.status ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff059669),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xffE5E7EB), width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTab("ISIN Analysis", 0),
                          const SizedBox(width: 24),
                          _buildTab("Pros & Cons", 1),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTabContent(company),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Column issuerDetails(company) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.5),
            ),
          ),
          child: const Text(
            'Issuer Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff020617),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Issue Name
              const Text(
                'Issue Name',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.issuerName ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              //Type of Issuer
              const Text(
                'Type of Issuer',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.typeOfIssuer ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Sector
              const Text(
                'Sector',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.sector ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              //Issuer naturer
              const Text(
                'Issuer Nature',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.issuerNature ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //cin
              const Text(
                'Corporate Identity Number (CIN)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.cin ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              //Lead Manager
              const Text(
                'Name of the lead Manager',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.leadManager ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Registrar
              const Text(
                'Registrar',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.registrar ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Name of Debenture Trustee
              const Text(
                'Name of Debenture Trustee',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1D4ED8),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                company.issuerDetails!.debentureTrustee ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff111827),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTabContent(dynamic company) {
    if (_selectedTabIndex == 0) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "COMPANY FINANCIALS",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffA3A3A3),
                            letterSpacing: 1.2,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOption = "EBITDA";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: selectedOption == "EBITDA" ? Colors.white : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "EBITDA",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: selectedOption == "EBITDA" ? Color(0xff171717) : Color(0xff737373),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOption = "Revenue";
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(6, 3, 8, 3),
                                  decoration: BoxDecoration(
                                    color: selectedOption == "Revenue" ? Colors.white : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "Revenue",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: selectedOption == "Revenue" ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: selectedOption == "EBITDA" ? _buildBarChartEbita() : _buildBarChartRevenue(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
            ),
            child: issuerDetails(company),
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: const Text(
                "Pros and Cons",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff020617),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pros',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff15803D),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (company.prosAndCons?.pros != null)
                      ...company.prosAndCons!.pros.map(
                        (pro) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/icons/TickIcon.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  pro,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff364153),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffB45309),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (company.prosAndCons?.cons != null)
                      ...company.prosAndCons!.cons.map(
                        (con) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/icons/ExclaimIcon.svg'),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  con,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  Widget _buildBarChartEbita() {
    return SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            minY: 0,
            maxY: 3.5,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
              horizontalInterval: 0.5,
              getDrawingHorizontalLine: (value) {
                if (value == 1 || value == 2 || value == 3) {
                  return const FlLine(
                    color: Color(0xffE5E5E5),
                    strokeWidth: 1,
                    dashArray: null,
                  );
                }
                return const FlLine(
                  color: Color(0xffE5E5E5),
                  strokeWidth: 0.5,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xffE5E5E5),
                  width: 1,
                ),
                top: BorderSide(
                  color: Color(0xffE5E5E5),
                  width: 0.5,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value == 1 || value == 2 || value == 3) {
                      return Text(
                        '₹${value.toInt()}L',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffA3A3A3),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xffA3A3A3)),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: List.generate(12, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: _isAnimated ? 1 : 0,
                    color: Colors.black,
                    width: 10,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                  BarChartRodData(
                    fromY: 0,
                    toY: _isAnimated ? 1.75 : 0,
                    color: Colors.blue.withOpacity(0.3),
                    width: 10,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    ),
                  ),
                ],
                groupVertically: true,
              );
            }),
            extraLinesData: ExtraLinesData(
              verticalLines: [
                VerticalLine(
                  x: 4.5,
                  color: Colors.grey,
                  dashArray: [5, 5],
                  strokeWidth: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartRevenue() {
    return SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            minY: 0,
            maxY: 3.5,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
              horizontalInterval: 0.5,
              getDrawingHorizontalLine: (value) {
                if (value == 1 || value == 2 || value == 3) {
                  return const FlLine(
                    color: Color(0xffE5E5E5),
                    strokeWidth: 1,
                    dashArray: null,
                  );
                }
                return const FlLine(
                  color: Color(0xffE5E5E5),
                  strokeWidth: 0.5,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(
                  color: Color(0xffE5E5E5),
                  width: 1,
                ),
                top: BorderSide(
                  color: Color(0xffE5E5E5),
                  width: 0.5,
                ),
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value == 1 || value == 2 || value == 3) {
                      return Text(
                        '₹${value.toInt()}L',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffA3A3A3),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        months[value.toInt()],
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xffA3A3A3)),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: List.generate(12, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: _isAnimated ? 1.75 : 0,
                    color: Colors.blue.withOpacity(0.3),
                    width: 10,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    ),
                  ),
                ],
                groupVertically: true,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedTabIndex == index ? const Color(0xff2563EB) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _selectedTabIndex == index ? const Color(0xff2563EB) : const Color(0xff4A5565),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffF9FAFB),
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xffE5E7EB),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x5258660F).withOpacity(0.06),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(padding: const EdgeInsets.all(9), child: SvgPicture.asset('assets/icons/ArrowLeft.svg')),
          ),
        ),
      ),
    );
  }
}
