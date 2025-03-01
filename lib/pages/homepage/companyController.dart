import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bonds/models/company_model.dart';

class CompanyController extends ChangeNotifier {
  final String apiUrl = 'https://eol122duf9sy4de.m.pipedream.net/';

  List<CompanyBond> _allCompanies = [];
  List<CompanyBond> _filteredCompanies = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<CompanyBond> get filteredCompanies => _filteredCompanies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchCompanies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final companyModel = CompanyModel.fromJson(jsonData);
        _allCompanies = companyModel.data;
        _filteredCompanies = List.from(_allCompanies);
      } else {
        _errorMessage = 'Failed to load data';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredCompanies = List.from(_allCompanies);
    } else {
      _filteredCompanies = _allCompanies
          .where((company) =>
              company.company_name
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              company.isin.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
