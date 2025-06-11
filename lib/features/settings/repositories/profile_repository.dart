import 'base_repository.dart';

class Profile {
  final String name;
  final String email;
  final double? annualSalary;
  final double? taxRate;
  final String? country;
  final String? currency;
  final bool? studentStatus;

  const Profile({
    required this.name,
    required this.email,
    this.annualSalary,
    this.taxRate,
    this.country,
    this.currency,
    this.studentStatus,
  });
}

class ProfileRepository extends BaseRepository {
  String _name = '';
  String _email = '';
  double? _annualSalary;
  double? _taxRate;
  String? _country;
  String? _currency;
  bool? _studentStatus;

  String get name => _name;
  String get email => _email;
  double? get annualSalary => _annualSalary;
  double? get taxRate => _taxRate;
  String? get country => _country;
  String? get currency => _currency;
  bool? get studentStatus => _studentStatus;

  Future<Profile> fetchProfile() async {
    // TODO: Implement Supabase fetch
    return Profile(
      name: _name,
      email: _email,
      annualSalary: _annualSalary,
      taxRate: _taxRate,
      country: _country,
      currency: _currency,
      studentStatus: _studentStatus,
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required double annualSalary,
    required double taxRate,
    String? country,
    String? currency,
    required bool studentStatus,
  }) async {
    _name = name;
    _email = email;
    _annualSalary = annualSalary;
    _taxRate = taxRate;
    _country = country;
    _currency = currency;
    _studentStatus = studentStatus;
    // TODO: Implement Supabase update
  }

  @override
  Future<void> initialize() async {
    // TODO: Load profile from Supabase
  }

  @override
  Future<void> dispose() async {
    // TODO: Save profile to Supabase
  }
} 