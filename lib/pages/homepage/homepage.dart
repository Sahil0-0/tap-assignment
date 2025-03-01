import 'package:bonds/pages/homepage/companyController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CompanyController>(context, listen: false)
            .fetchCompanies());
  }

  @override
  Widget build(BuildContext context) {
    final companyController = Provider.of<CompanyController>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F4F6),
        scrolledUnderElevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(companyController),
            const SizedBox(height: 20),
            const Text(
              'SUGGESTED RESULTS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF99A1AF),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: companyList(companyController)),
          ],
        ),
      ),
    );
  }

  Widget searchBar(CompanyController controller) {
    return TextField(
      onChanged: controller.updateSearchQuery,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SvgPicture.asset('assets/icons/MagnifyingGlass.svg'),
        ),
        hintText: 'Search by Issuer Name or ISIN',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget companyList(CompanyController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(child: Text('Error: ${controller.errorMessage}'));
    }

    if (controller.filteredCompanies.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.filteredCompanies.length,
        itemBuilder: (context, index) {
          final company = controller.filteredCompanies[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            visualDensity: VisualDensity.compact,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 0.4),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(company.logo, fit: BoxFit.fill),
                ),
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: highlightSearchText(
                    company.isin, controller.searchQuery, 'Isin'),
              ),
            ),
            subtitle: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: highlightSearchText(
                        company.rating, controller.searchQuery, 'ratings'),
                  ),
                ),
                const Text(
                  ' \u2022 ',
                  style: TextStyle(color: Color(0xFF99A1AF), fontSize: 10),
                ),
                RichText(
                  text: TextSpan(
                    children: highlightSearchText(company.company_name,
                        controller.searchQuery, 'company_name'),
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff1447E6),
              size: 10,
            ),
          );
        },
      ),
    );
  }

  List<TextSpan> highlightSearchText(
      String text, String query, String valueType) {
    final matches = RegExp(query, caseSensitive: false).allMatches(text);
    if (query.isEmpty || matches.isEmpty) {
      if (valueType == 'Isin') {
        return [
          TextSpan(
            text: text.substring(0, 8),
            style: const TextStyle(
              color: Color(0xFF6A7282),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: text.substring(8),
            style: const TextStyle(
              color: Color(0xff1E2939),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ];
      } else {
        return [
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Color(0xFF99A1AF),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ];
      }
    }

    List<TextSpan> spans = [];
    int start = 0;

    for (var match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: TextStyle(
              color: valueType == 'Isin'
                  ? const Color(0xFF1E2939)
                  : const Color(0xFF99A1AF),
              fontWeight:
                  valueType == 'Isin' ? FontWeight.w500 : FontWeight.w400,
              fontSize: valueType == 'Isin' ? 12 : 10,
            ),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(
            color: valueType == 'Isin'
                ? const Color(0xFF1E2939)
                : const Color(0xFF99A1AF),
            backgroundColor: Colors.orange.withOpacity(0.25),
            fontWeight: valueType == 'Isin' ? FontWeight.w500 : FontWeight.w400,
            fontSize: valueType == 'Isin' ? 12 : 10,
          ),
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: TextStyle(
            color: valueType == 'Isin'
                ? const Color(0xFF1E2939)
                : const Color(0xFF99A1AF),
            fontSize: valueType == 'Isin' ? 12 : 10,
            fontWeight: valueType == 'Isin' ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      );
    }

    return spans;
  }
}
