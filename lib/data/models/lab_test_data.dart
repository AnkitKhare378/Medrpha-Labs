// lib/data/lab_test_data.dart

class LabTestData {
  // Static list for search suggestions
  static const List<String> searchTexts = [
    "Vitamin D Tests",
    "Full Body Checkup",
    "Thyroid Function",
    "Diabetes Profile",
    "Lipid Profile",
    "CBC Test",
  ];

  // Static list of lab test details
  static const List<Map<String, String>> tests = [
    {
      "name": "Fat - Soluble Vitamins Profile (A,D,E,K)",
      "price": "₹1,800.00",
      "originalPrice": "₹2,160.00",
      "discount": "17% OFF",
      "fasting": "Fasting Required",
      "lab": "Thyrocare Technologies",
    },
    {
      "name": "25 Oh Vitamin D (Total) (D2+D3)",
      "price": "₹700.00",
      "originalPrice": "₹1,200.00",
      "discount": "42% OFF",
      "fasting": "Fasting Not Required",
      "lab": "Thyrocare Technologies",
    },
    {
      "name": "Homocysteine (HCY)",
      "price": "₹585.00",
      "originalPrice": "₹850.00",
      "discount": "31% OFF",
      "fasting": "Fasting Not Required",
      "lab": "NirAmaya Pathlabs",
    },
    {
      "name": "Thyroid Profile Total (T3, T4 & TSH)",
      "price": "₹450.00",
      "originalPrice": "₹700.00",
      "discount": "36% OFF",
      "fasting": "Fasting Not Required",
      "lab": "Lal PathLabs",
    },
    {
      "name": "Complete Blood Count (CBC)",
      "price": "₹300.00",
      "originalPrice": "₹500.00",
      "discount": "40% OFF",
      "fasting": "Fasting Not Required",
      "lab": "Apollo Diagnostics",
    },
  ];
}