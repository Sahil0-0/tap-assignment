class CompanyDetailModel {
  CompanyDetailModel({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.isin,
    required this.status,
    required this.prosAndCons,
    required this.financials,
    required this.issuerDetails,
  });

  final String? logo;
  final String? companyName;
  final String? description;
  final String? isin;
  final String? status;
  final ProsAndCons? prosAndCons;
  final Financials? financials;
  final IssuerDetails? issuerDetails;

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
      logo: json["logo"],
      companyName: json["company_name"],
      description: json["description"],
      isin: json["isin"],
      status: json["status"],
      prosAndCons: json["pros_and_cons"] == null
          ? null
          : ProsAndCons.fromJson(json["pros_and_cons"]),
      financials: json["financials"] == null
          ? null
          : Financials.fromJson(json["financials"]),
      issuerDetails: json["issuer_details"] == null
          ? null
          : IssuerDetails.fromJson(json["issuer_details"]),
    );
  }
}

class Financials {
  Financials({
    required this.ebitda,
    required this.revenue,
  });

  final List<Ebitda> ebitda;
  final List<Ebitda> revenue;

  factory Financials.fromJson(Map<String, dynamic> json) {
    return Financials(
      ebitda: json["ebitda"] == null
          ? []
          : List<Ebitda>.from(json["ebitda"]!.map((x) => Ebitda.fromJson(x))),
      revenue: json["revenue"] == null
          ? []
          : List<Ebitda>.from(json["revenue"]!.map((x) => Ebitda.fromJson(x))),
    );
  }
}

class Ebitda {
  Ebitda({
    required this.month,
    required this.value,
  });

  final String? month;
  final int? value;

  factory Ebitda.fromJson(Map<String, dynamic> json) {
    return Ebitda(
      month: json["month"],
      value: json["value"],
    );
  }
}

class IssuerDetails {
  IssuerDetails({
    required this.issuerName,
    required this.typeOfIssuer,
    required this.sector,
    required this.industry,
    required this.issuerNature,
    required this.cin,
    required this.leadManager,
    required this.registrar,
    required this.debentureTrustee,
  });

  final String? issuerName;
  final String? typeOfIssuer;
  final String? sector;
  final String? industry;
  final String? issuerNature;
  final String? cin;
  final String? leadManager;
  final String? registrar;
  final String? debentureTrustee;

  factory IssuerDetails.fromJson(Map<String, dynamic> json) {
    return IssuerDetails(
      issuerName: json["issuer_name"],
      typeOfIssuer: json["type_of_issuer"],
      sector: json["sector"],
      industry: json["industry"],
      issuerNature: json["issuer_nature"],
      cin: json["cin"],
      leadManager: json["lead_manager"],
      registrar: json["registrar"],
      debentureTrustee: json["debenture_trustee"],
    );
  }
}

class ProsAndCons {
  ProsAndCons({
    required this.pros,
    required this.cons,
  });

  final List<String> pros;
  final List<String> cons;

  factory ProsAndCons.fromJson(Map<String, dynamic> json) {
    return ProsAndCons(
      pros: json["pros"] == null
          ? []
          : List<String>.from(json["pros"]!.map((x) => x)),
      cons: json["cons"] == null
          ? []
          : List<String>.from(json["cons"]!.map((x) => x)),
    );
  }
}
