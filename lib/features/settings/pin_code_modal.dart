import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../settings/bloc/preferences_bloc.dart';
import '../settings/bloc/preferences_state.dart';
import '../settings/bloc/preferences_event.dart';

class PinCodeModal extends StatefulWidget {
  const PinCodeModal({super.key});

  @override
  State<PinCodeModal> createState() => _PinCodeModalState();
}

class _PinCodeModalState extends State<PinCodeModal> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesBloc = context.read<PreferencesBloc>();
    return BlocListener<PreferencesBloc, PreferencesState>(
      listenWhen: (prev, curr) => prev.pinSaved != curr.pinSaved,
      listener: (context, state) {
        if (state.pinSaved == true) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('PIN saved')),
          );
        }
      },
      child: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PIN Code', style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        preferencesBloc.add(PinModalClosed());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pinController,
                  decoration: const InputDecoration(labelText: 'Enter New PIN'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  decoration: const InputDecoration(labelText: 'Confirm PIN'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: AppTextStyles.bodyLarge,
                ),
                if (state.pinError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      state.pinError,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neutral900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => preferencesBloc.add(
                      SavePinRequested(_pinController.text, _confirmController.text),
                    ),
                    child: Text('Save PIN', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 