import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bonds/models/company_model.dart';

class CompanyController extends ChangeNotifier {
  final String apiUrl = 'https://eol122duf9sy4de.m.pipedream.net/';

  List<CompanyBond> _allCompanies = [];
  List<CompanyBond> _filteredCompanies = [];
  String searchQuery = '';
  bool isLoading = false;
  bool isSearching = false;
  String? _errorMessage;

  List<CompanyBond> get filteredCompanies => _filteredCompanies;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCompanies() async {
    isLoading = true;
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

    isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    _filteredCompanies.clear();

    if (query.isEmpty) {
      _filteredCompanies = List.from(_allCompanies);
    } else {
      isSearching = true;
      List<String> searchWords = query.toLowerCase().split(' ');
      _filteredCompanies = _allCompanies.where((company) {
        return searchWords.every(
            (word) => company.company_name.toLowerCase().contains(word) || company.isin.toLowerCase().contains(word));
      }).toList();
    }

    notifyListeners();
  }
}
