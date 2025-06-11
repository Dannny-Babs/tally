import 'package:flutter/services.dart';
import '../../../utils/utils.dart';

class PinCodeModal extends StatefulWidget {
  const PinCodeModal({super.key});

  @override
  State<PinCodeModal> createState() => _PinCodeModalState();
}

class _PinCodeModalState extends State<PinCodeModal> {
  final int pinLength = 4;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(pinLength, (index) => TextEditingController());
    _focusNodes = List.generate(pinLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onPinDigitChanged(int index, String value) {
    if (value.length == 1 && index < pinLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String _getPinCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  bool _isPinComplete() {
    return _controllers.every((controller) => controller.text.length == 1);
  }

  @override
  Widget build(BuildContext context) {
    final preferencesBloc = context.read<PreferencesBloc>();
    return BlocListener<PreferencesBloc, PreferencesState>(
      listenWhen: (prev, curr) => prev.pinCode != curr.pinCode,
      listener: (context, state) {
        if (state.pinCode.isNotEmpty) {
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
                    Text(
                      'PIN Code',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Enter a 4-digit PIN code',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral800,
                    letterSpacing: 0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    pinLength,
                    (index) => SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.borderLight,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.backgroundLight,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onPinDigitChanged(index, value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.neutral900,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _isPinComplete()
                        ? () {
                            final pin = _getPinCode();
                            preferencesBloc.add(PinCodeSaved(pin));
                          }
                        : null,
                    child: Text(
                      'Save PIN',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
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
