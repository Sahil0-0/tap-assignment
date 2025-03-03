import 'package:bonds/pages/company_bond_details/companyDetailsPage.dart';
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
    // ignore: use_build_context_synchronously
    Future.microtask(() => Provider.of<CompanyController>(context, listen: false).fetchCompanies());
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
            GestureDetector(
              child: companyList(companyController),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyDetailsPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget searchBar(CompanyController controller) {
    return TextField(
      onChanged: controller.updateSearchQuery,
      cursorColor: const Color.fromRGBO(0, 0, 0, 1),
      cursorHeight: 12,
      cursorWidth: 1,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.errorMessage != null) {
      return Center(child: Text('Error: ${controller.errorMessage}'));
    }

    if (controller.filteredCompanies.isEmpty) {
      return const Center(child: Text('No results found.'));
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: (controller.filteredCompanies.length * 70.0).clamp(0, MediaQuery.of(context).size.height * 0.7),
      padding: const EdgeInsets.symmetric(vertical: 6),
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              decoration: BoxDecoration(
                  border: index < controller.filteredCompanies.length - 1 && controller.searchQuery != ''
                      ? const Border(
                          bottom: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 0.4,
                          ),
                        )
                      : null),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                minLeadingWidth: 0,
                minTileHeight: 0,
                minVerticalPadding: 0,
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
                      child: Image.network(
                        company.logo,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    children: highlightSearchText(company.isin, controller.searchQuery, 'Isin'),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: highlightSearchText(company.rating, controller.searchQuery, 'ratings'),
                        ),
                      ),
                      const Text(
                        ' \u2022 ',
                        style: TextStyle(color: Color(0xFF99A1AF), fontSize: 10),
                      ),
                      RichText(
                        text: TextSpan(
                          children: highlightSearchText(company.company_name, controller.searchQuery, 'company_name'),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff1447E6),
                  size: 10,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<InlineSpan> highlightSearchText(String text, String query, String valueType) {
    if (query.isEmpty || query == '') {
      return [_normalTextSpan(text, valueType)];
    }

    List<String> searchWords = query.toLowerCase().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    List<InlineSpan> spans = [];
    int start = 0;

    List<RegExpMatch> allMatches = [];
    for (String word in searchWords) {
      allMatches.addAll(RegExp(RegExp.escape(word), caseSensitive: false).allMatches(text));
    }

    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (var match in allMatches) {
      if (match.start >= start) {
        if (match.start > start) {
          spans.add(_normalTextSpan(text.substring(start, match.start), valueType));
        }

        spans.add(_inlineHighlightedText(text.substring(match.start, match.end), valueType));

        start = match.end;
      }
    }

    if (start < text.length) {
      spans.add(_normalTextSpan(text.substring(start), valueType));
    }

    return spans;
  }

  TextSpan _normalTextSpan(String text, String valueType) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: valueType == 'Isin' ? const Color(0xFF1E2939) : const Color(0xFF99A1AF),
        fontSize: valueType == 'Isin' ? 12 : 10,
        fontWeight: valueType == 'Isin' ? FontWeight.w500 : FontWeight.w400,
      ),
    );
  }

  InlineSpan _inlineHighlightedText(String text, String valueType) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: valueType == 'Isin' ? const Color(0xFF1E2939) : const Color(0xFF99A1AF),
            fontSize: valueType == 'Isin' ? 12 : 10,
            fontWeight: valueType == 'Isin' ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
