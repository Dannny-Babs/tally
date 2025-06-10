import 'package:equatable/equatable.dart';
import '../../models/payback.dart';

enum PaybacksStatus { initial, loading, success, error }

class PaybacksState extends Equatable {
  final List<Payback> paybacks;
  final String currentTab; // "personal", "credit", "debt"
  final PaybacksStatus status;
  final String? errorMessage;

  const PaybacksState({
    this.paybacks = const [],
    this.currentTab = 'personal',
    this.status = PaybacksStatus.initial,
    this.errorMessage,
  });

  PaybacksState copyWith({
    List<Payback>? paybacks,
    String? currentTab,
    PaybacksStatus? status,
    String? errorMessage,
  }) {
    return PaybacksState(
      paybacks: paybacks ?? this.paybacks,
      currentTab: currentTab ?? this.currentTab,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [paybacks, currentTab, status, errorMessage];
} 