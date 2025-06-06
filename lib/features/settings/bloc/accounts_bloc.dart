import 'package:flutter_bloc/flutter_bloc.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc() : super(const AccountsState(savingsCount: 3, savingsList: [], giftsList: [])) {
    on<SavingsTapped>((event, emit) {
      // Navigation or logic can be handled here
    });
    on<GiftsTapped>((event, emit) {
      // Navigation or logic can be handled here
    });
  }
} 