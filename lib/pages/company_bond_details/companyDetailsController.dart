import 'dart:convert';
import 'package:bonds/models/company_details_bond.dart';
import 'package:http/http.dart' as http;

class CompanyDetailsController {
  final String apiUrl = 'https://eo61q3zd4heiwke.m.pipedream.net/';

  get financials => null;

  Future<CompanyDetailModel> fetchCompanyDetails() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return CompanyDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company details');
    }
  }
}
