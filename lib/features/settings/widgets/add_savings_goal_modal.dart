import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../utils/utils.dart';
import '../bloc/savings/savings_bloc.dart';
import '../bloc/savings/savings_event.dart';
import '../bloc/savings/savings_state.dart';

class AddSavingsGoalModal extends StatefulWidget {
  final SavingsGoal? existing;

  const AddSavingsGoalModal({super.key, this.existing});

  @override
  State<AddSavingsGoalModal> createState() => _AddSavingsGoalModalState();
}

class _AddSavingsGoalModalState extends State<AddSavingsGoalModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _initialContributionController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _targetDate;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _nameController.text = widget.existing!.name;
      _targetAmountController.text = widget.existing!.targetAmount.toString();
      _initialContributionController.text =
          widget.existing!.currentAmount.toString();
      _notesController.text = widget.existing!.notes ?? '';
      _targetDate = widget.existing!.targetDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _initialContributionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          isEditing ? 'Edit Savings Goal' : 'Add Savings Goal',
                          style: AppTextStyles.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        LabeledInput(
                          enabled: false,
                          label: 'Goal Name',
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a goal name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        LabeledInput(
                          enabled: false,
                          label: 'Target Amount',
                          child: TextFormField(
                            controller: _targetAmountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        LabeledInput(
                          enabled: false,
                          label: 'Initial Contribution',
                          child: TextFormField(
                            controller: _initialContributionController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _targetDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 3650)),
                            );
                            if (date != null) {
                              setState(() {
                                _targetDate = date;
                              });
                            }
                          },
                          child: LabeledInput(
                            enabled: false,
                            label: 'Target Date',
                            child: TextFormField(
                              controller: TextEditingController(
                                text: _targetDate != null
                                    ? DateFormat('MMM d, y')
                                        .format(_targetDate!)
                                    : 'Select a date',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LabeledInput(
                          enabled: false,
                          label: 'Notes (Optional)',
                          child: TextFormField(
                            controller: _notesController,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final event = isEditing
                                  ? UpdateSavingsGoalSubmitted(
                                      id: widget.existing!.id,
                                      name: _nameController.text,
                                      targetAmount: double.parse(
                                          _targetAmountController.text),
                                      targetDate: _targetDate!,
                                      notes: _notesController.text.isEmpty
                                          ? null
                                          : _notesController.text,
                                    )
                                  : AddSavingsGoalSubmitted(
                                      name: _nameController.text,
                                      targetAmount: double.parse(
                                          _targetAmountController.text),
                                      initialContribution: double.parse(
                                          _initialContributionController.text),
                                      targetDate: _targetDate!,
                                      notes: _notesController.text.isEmpty
                                          ? null
                                          : _notesController.text,
                                    );
                              context.read<SavingsBloc>().add(event);
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neutral900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'Update Goal' : 'Add Goal',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ],
                    ),
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
