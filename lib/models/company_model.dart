class CompanyModel {
  final List<CompanyBond> data;

  CompanyModel({required this.data});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      data: List<CompanyBond>.from(
          json['data'].map((x) => CompanyBond.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class CompanyBond {
  final String logo;
  final String isin;
  final String rating;
  final String company_name;
  final List<String> tags;

  CompanyBond({
    required this.logo,
    required this.isin,
    required this.rating,
    required this.company_name,
    required this.tags,
  });

  factory CompanyBond.fromJson(Map<String, dynamic> json) {
    return CompanyBond(
      logo: json['logo'] ?? '',
      isin: json['isin'] ?? '',
      rating: json['rating'] ?? '',
      company_name: json['company_name'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'isin': isin,
      'rating': rating,
      'company_name': company_name,
      'tags': tags,
    };
  }
}
