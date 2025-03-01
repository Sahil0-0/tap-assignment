import 'package:bonds/models/company_details_bond.dart';
import 'package:bonds/pages/company_bond_details/companyDetailsController.dart';
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

  final CompanyDetailsController _controller = CompanyDetailsController();

  @override
  void initState() {
    super.initState();
    _futureCompanyDetails = _controller.fetchCompanyDetails();
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
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          company.description ?? 'No Description',
                          style: const TextStyle(
                              color: Color(0xff6A7282),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xff2563EB).withOpacity(0.1),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                'ISIN: ${company.isin ?? 'N/A'}',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff2563EB)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
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
                ],
              ),
            );
          }
        },
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
              color: _selectedTabIndex == index
                  ? const Color(0xff2563EB)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _selectedTabIndex == index
                ? const Color(0xff2563EB)
                : Colors.grey,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
                padding: const EdgeInsets.all(9),
                child: SvgPicture.asset('assets/icons/ArrowLeft.svg')),
          ),
        ),
      ),
    );
  }
}
