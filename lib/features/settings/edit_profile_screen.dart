import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/platform_back_button.dart';
import 'bloc/profile/profile.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _salaryController;
  late TextEditingController _taxRateController;
  late String _country;
  late String _currency;
  late bool _studentStatus;

  final List<String> _countries = [
    '🇨🇦 Canada',
    '🇺🇸 United States',
    '🇬🇧 United Kingdom',
    '🇦🇺 Australia',
    '🇩🇪 Germany',
    '🇫🇷 France',
    '🇯🇵 Japan',
    '🇮🇳 India',
    '🇧🇷 Brazil',
    '🇲🇽 Mexico',
  ];

  final List<String> _currencies = [
    'CAD - Canadian Dollar',
    'USD - US Dollar',
    'EUR - Euro',
    'GBP - British Pound',
    'JPY - Japanese Yen',
    'AUD - Australian Dollar',
    'INR - Indian Rupee',
    'BRL - Brazilian Real',
    'MXN - Mexican Peso',
  ];

  String _getCountryCode(String displayName) {
    final codes = {
      '🇨🇦 Canada': 'CA',
      '🇺🇸 United States': 'US',
      '🇬🇧 United Kingdom': 'GB',
      '🇦🇺 Australia': 'AU',
      '🇩🇪 Germany': 'DE',
      '🇫🇷 France': 'FR',
      '🇯🇵 Japan': 'JP',
      '🇮🇳 India': 'IN',
      '🇧🇷 Brazil': 'BR',
      '🇲🇽 Mexico': 'MX',
    };
    return codes[displayName] ?? 'US';
  }

  String _getCurrencyCode(String displayName) {
    final codes = {
      'CAD - Canadian Dollar': 'CAD',
      'USD - US Dollar': 'USD',
      'EUR - Euro': 'EUR',
      'GBP - British Pound': 'GBP',
      'JPY - Japanese Yen': 'JPY',
      'AUD - Australian Dollar': 'AUD',
      'INR - Indian Rupee': 'INR',
      'BRL - Brazilian Real': 'BRL',
      'MXN - Mexican Peso': 'MXN',
    };
    return codes[displayName] ?? 'USD';
  }

  String _getCountryDisplay(String code) {
    final displays = {
      'CA': '🇨🇦 Canada',
      'US': '🇺🇸 United States',
      'GB': '🇬🇧 United Kingdom',
      'AU': '🇦🇺 Australia',
      'DE': '🇩🇪 Germany',
      'FR': '🇫🇷 France',
      'JP': '🇯🇵 Japan',
      'IN': '🇮🇳 India',
      'BR': '🇧🇷 Brazil',
      'MX': '🇲🇽 Mexico',
    };
    return displays[code] ?? '🇺🇸 United States';
  }

  String _getCurrencyDisplay(String code) {
    final displays = {
      'CAD': 'CAD - Canadian Dollar',
      'USD': 'USD - US Dollar',
      'EUR': 'EUR - Euro',
      'GBP': 'GBP - British Pound',
      'JPY': 'JPY - Japanese Yen',
      'AUD': 'AUD - Australian Dollar',
      'INR': 'INR - Indian Rupee',
      'BRL': 'BRL - Brazilian Real',
      'MXN': 'MXN - Mexican Peso',
    };
    return displays[code] ?? 'USD - US Dollar';
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state;
    _nameController = TextEditingController(text: state.name);
    _emailController = TextEditingController(text: state.email);
    _salaryController = TextEditingController(
      text: state.annualSalary?.toString() ?? '0',
    );
    _taxRateController = TextEditingController(
      text: state.taxRate?.toString() ?? '0',
    );
    _country = _getCountryDisplay(state.country ?? 'US');
    _currency = _getCurrencyDisplay(state.currency ?? 'USD');
    _studentStatus = state.studentStatus ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const PlatformBackButton(),
        title: Text(
          'Edit Profile',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pop(context);
          } else if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to update profile'),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name
                  Text(
                    'Full Name',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary500),
                      ),
                    ),
                    validator:
                        (v) =>
                            v?.isEmpty ?? true
                                ? 'Please enter your name'
                                : null,
                  ),
                  const SizedBox(height: 24),

                  // Email
                  Text(
                    'Email',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary500),
                      ),
                    ),
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Please enter your email';
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(v!)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Annual Salary
                  Text(
                    'Annual Salary',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your annual salary',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary500),
                      ),
                    ),
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Please enter your salary';
                      final salary = double.tryParse(v!);
                      if (salary == null || salary < 0) {
                        return 'Please enter a valid salary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tax Rate
                  Text(
                    'Tax Rate (%)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _taxRateController,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your tax rate',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryLight.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary500),
                      ),
                    ),
                    validator: (v) {
                      if (v?.isEmpty ?? true) {
                        return 'Please enter your tax rate';
                      }
                      final rate = double.tryParse(v!);
                      if (rate == null || rate < 0 || rate > 100) {
                        return 'Please enter a valid tax rate (0-100)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Country Selection
                  Text(
                    'Country',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _country,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        borderRadius: BorderRadius.circular(12),
                        items:
                            _countries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(
                                  country,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _country = newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Currency Selection
                  Text(
                    'Currency',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currency,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        borderRadius: BorderRadius.circular(12),
                        items:
                            _currencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(
                                  currency,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() => _currency = newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Student Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Student Status',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.neutral800,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _studentStatus,
                          onChanged:
                              (value) => setState(() => _studentStatus = value),
                          activeColor: Colors.white,
                          inactiveThumbColor: AppColors.neutral400,
                          inactiveTrackColor: AppColors.neutral400,
                          activeTrackColor: AppColors.primary900,
                          trackOutlineWidth: WidgetStateProperty.all(0.0),
                          trackOutlineColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          thumbColor: WidgetStateProperty.all(Colors.white),
                          splashRadius: 12,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (prev, curr) => prev.status != curr.status,
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed:
                              state.status == ProfileStatus.loading
                                  ? null
                                  : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<ProfileBloc>().add(
                                        ProfileUpdated(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          annualSalary:
                                              double.tryParse(
                                                _salaryController.text.trim(),
                                              ) ??
                                              0,
                                          taxRate:
                                              double.tryParse(
                                                _taxRateController.text.trim(),
                                              ) ??
                                              0,
                                          country: _getCountryCode(_country),
                                          currency: _getCurrencyCode(_currency),
                                          studentStatus: _studentStatus,
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: AppColors.primary500
                                .withOpacity(0.5),
                          ),
                          child:
                              state.status == ProfileStatus.loading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'Save Changes',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
