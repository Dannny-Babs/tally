import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tally/core/widgets/labeled_input.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTag;
  String? _selectedPaymentMethod;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRecurring = false;
  String? _recurrenceFrequency;
  DateTime? _recurrenceEndDate;
  File? _receiptFile;

  final List<String> _paymentMethods = [
    'Bank',
    'Cash',
    'Card',
    'PayPal',
    'Other',
  ];

  final List<String> _recurrenceOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(CategoriesLoaded());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _descriptionController.dispose();
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

  Future<void> _selectRecurrenceEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recurrenceEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        _recurrenceEndDate = picked;
      });
    }
  }

  Future<void> _pickReceipt() async {
    print('pickReceipt started');
    try {
      print('Creating ImagePicker instance');
      final ImagePicker picker = ImagePicker();
      print('Calling pickImage');
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      print('Image picker result: ${image?.path}');

      if (image != null) {
        print('Setting receipt file');
        setState(() {
          _receiptFile = File(image.path);
        });
        print('Receipt file set successfully');
      } else {
        print('No image selected');
      }
    } catch (e, stackTrace) {
      print('Error picking image: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                color: Colors.black.withOpacity(0.1),
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
                              'Add Expense',
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColors.neutral900,
                                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                fontSize: 20,
                                letterSpacing: -0.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Log a new expense to track your spending',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondaryLight,
                                letterSpacing: -0.15,
                                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
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
                      LabeledInput(
                        label: 'Amount',
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
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} • ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.neutral900,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      LabeledInput(
                        label: 'Category',
                        child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoryLoaded) {
                              return Container(
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
                                      'Select category',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.neutral800,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: -0.15,
                                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                      ),
                                    ),
                                    items: state.categories
                                        .map(
                                          (category) => DropdownMenuItem<String>(
                                            value: category.name,
                                            child: Text(
                                              category.name,
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                color: AppColors.neutral900,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.15,
                                                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    value: _selectedCategory,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                    },
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                      LabeledInput(
                        label: 'Payment Method',
                        child: Container(
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
                                'Select method',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.neutral800,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -0.15,
                                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                ),
                              ),
                              items: _paymentMethods
                                  .map(
                                    (method) => DropdownMenuItem<String>(
                                      value: method,
                                      child: Text(
                                        method,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.neutral900,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.15,
                                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
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
                      ),

                      const SizedBox(height: 16),
                      LabeledInput(
                        label: 'Description',
                        child: TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: 'What was this expense for?',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      LabeledInput(
                        label: 'Receipt',
                        child: InkWell(
                          onTap: () {
                            print('Receipt tap detected');
                            _pickReceipt();
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: _receiptFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _receiptFile!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          HugeIconsSolid.imageUpload01,
                                          size: 24,
                                          color: AppColors.neutral800,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Tap to attach receipt',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.neutral700,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: -0.15,
                                            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      LabeledInput(
                        label: 'Notes',
                        child: TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Add a note (optional)',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(
                          'Repeat this expense',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.15,
                          ),
                        ),
                        subtitle: Text(
                          'Set up recurring expense',
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
                          });
                        },
                      ),

                      if (_isRecurring) ...[
                        const SizedBox(height: 16),
                        LabeledInput(
                          label: 'Frequency',
                          child: Container(
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
                                  'Select frequency',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.neutral800,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: -0.15,
                                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                  ),
                                ),
                                items: _recurrenceOptions
                                    .map(
                                      (option) => DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(
                                          option,
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: AppColors.neutral900,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: -0.15,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: _recurrenceFrequency,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _recurrenceFrequency = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LabeledInput(
                          label: 'End Date',
                          child: InkWell(
                            onTap: _selectRecurrenceEndDate,
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _recurrenceEndDate != null
                                        ? 'Ends on ${_recurrenceEndDate!.day}/${_recurrenceEndDate!.month}/${_recurrenceEndDate!.year}'
                                        : 'Select end date',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.neutral900,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.15,
                                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                                    ),
                                  ),
                                ],
                              ),
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
                              if (_selectedCategory == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Select a category'),
                                  ),
                                );
                                return;
                              }

                              if (_selectedTag == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Select a tag'),
                                  ),
                                );
                                return;
                              }

                              if (_selectedPaymentMethod == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Select a payment method'),
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
                                AddExpenseSubmitted(
                                  amount: amount,
                                  category: _selectedCategory!,
                                  description: _descriptionController.text,
                                  date: _selectedDate,
                                  time: _selectedTime,
                                  tags: [_selectedTag!],
                                  notes: _notesController.text.isEmpty
                                      ? null
                                      : _notesController.text,
                                  paymentMethod: _selectedPaymentMethod!,
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
                            'Save Expense',
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
}
