// TODO (Phase C): Split this file into header, form, summary, filter, list widget files
// TODO (Phase D): Move business logic (calculations, grouping, formatting) out of build() into Bloc or Utils
// TODO (Phase E): Replace CircularProgressIndicator with ShimmerLoader in Phase B

import 'package:flutter/services.dart';

import '../../../../utils/utils.dart';
import '../../widgets/exports.dart';

class AddIncomeModal extends StatefulWidget {
  const AddIncomeModal({super.key});

  @override
  State<AddIncomeModal> createState() => _AddIncomeModalState();
}

class _AddIncomeModalState extends State<AddIncomeModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _sourceController = TextEditingController();

  String? _selectedSource;
  String? _selectedPaymentMethod;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isTaxable = true;
  bool _isRecurring = false;
  String? _recurrenceFrequency;

  final List<String> _sources = ['Freelance', 'Job', 'Business', 'Other'];
  final List<String> _paymentMethods = [
    'Bank',
    'Cash',
    'PayPal',
    'Credit Card',
    'Other',
  ];
  final List<String> _recurrenceOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];
  final List<String> _selectedCategories = [];
  final List<String> _categories = [
    'Salary',
    'Freelance',
    'Bonus',
    'Investment',
    'Gift',
    'Refund',
    'Other',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid amount > 0';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount > 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO (Phase C): Extract this block into a shared widget
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Income',
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColors.neutral900,
                                fontFamily:
                                    GoogleFonts.spaceGrotesk().fontFamily,
                                fontSize: 20,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Log a new payment to keep your earnings up-to-date',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryLight,
                                letterSpacing: -0.15,
                                fontFamily:
                                    GoogleFonts.spaceGrotesk().fontFamily,

                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Amount',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.15,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 48,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            prefixText: '\$ ',
                          ),
                          validator: _validateAmount,
                        ),
                      ),

                      const SizedBox(height: 16),

                      LabeledInput(
                        label: 'Date & Time',
                        child: InkWell(
                          onTap: () async {
                            await _selectDate();
                            await _selectTime();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                  ),
                                ),
                                Text(
                                  _selectedTime.format(context),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryLight,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                    fontFamily:
                                        GoogleFonts.spaceGrotesk().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Source',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.15,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Choose or type source',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.neutral800,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: -0.15,
                                fontFamily:
                                    GoogleFonts.spaceGrotesk().fontFamily,
                              ),
                            ),
                            items:
                                _sources
                                    .map(
                                      (source) => DropdownMenuItem<String>(
                                        value: source,
                                        child: Text(
                                          source,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.neutral900,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.15,
                                                fontFamily:
                                                    GoogleFonts.spaceGrotesk()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            value: _selectedSource,
                            onChanged: (value) {
                              setState(() {
                                _selectedSource = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Payment Method',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.15,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borderLight,
                                ),
                              ),
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Select method',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.neutral800,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: -0.15,
                                fontFamily:
                                    GoogleFonts.spaceGrotesk().fontFamily,
                              ),
                            ),
                            items:
                                _paymentMethods
                                    .map(
                                      (method) => DropdownMenuItem<String>(
                                        value: method,
                                        child: Text(
                                          method,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                color: AppColors.neutral900,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.15,
                                                fontFamily:
                                                    GoogleFonts.spaceGrotesk()
                                                        .fontFamily,
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            value: _selectedPaymentMethod,
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Category / Tag',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.15,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      MultiSelector(
                        options: _categories,
                        selectedOptions: _selectedCategories,
                        onOptionSelected: (option) {
                          setState(() {
                            _selectedCategories.add(option);
                          });
                        },
                        onOptionDeselected: (option) {
                          setState(() {
                            _selectedCategories.remove(option);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Notes',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: -0.15,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Optional... add a note',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: -0.15,
                            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(
                          'Is Taxable?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.15,
                          ),
                        ),
                        subtitle: Text(
                          'Include this in tax calculations',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -0.15,
                          ),
                        ),
                        value: _isTaxable,
                        onChanged: (bool value) {
                          setState(() {
                            _isTaxable = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Recurring?',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.15,
                          ),
                        ),
                        subtitle: Text(
                          'Set up repeat frequency',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: -0.15,
                          ),
                        ),
                        value: _isRecurring,
                        onChanged: (bool value) {
                          setState(() {
                            _isRecurring = value;
                            if (!value) _recurrenceFrequency = null;
                          });
                        },
                      ),
                      if (_isRecurring) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Recurrence Frequency',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.borderLight,
                                  ),
                                ),
                              ),
                              isExpanded: true,
                              hint: Text(
                                'Select frequency',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              value: _recurrenceFrequency,
                              items:
                                  _recurrenceOptions.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(
                                        option,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.neutral900,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              letterSpacing: -0.15,
                                            ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _recurrenceFrequency = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedCategories.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Select at least one category',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final amount = double.tryParse(
                                _amountController.text,
                              );
                              if (amount == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Enter a valid amount > 0'),
                                  ),
                                );
                                return;
                              }

                              context.read<TransactionBloc>().add(
                                AddIncomeSubmitted(
                                  amount: amount,
                                  source: _selectedSource!,
                                  description: _selectedCategories.first,
                                  date: _selectedDate,
                                  time: _selectedTime,
                                  categories: _selectedCategories,
                                  notes:
                                      _notesController.text.isEmpty
                                          ? null
                                          : _notesController.text,
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neutral900,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save Income',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        children: [
          // Form fields will be moved here in Phase C
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
