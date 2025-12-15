import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/top_up.dart';
import '../../domain/usecases/get_transaction_history.dart';
import '../../domain/usecases/get_top_up_history.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final TopUp topUp;
  final GetTransactionHistory getTransactionHistory;
  final GetTopUpHistory getTopUpHistory;

  WalletBloc({
    required this.topUp,
    required this.getTransactionHistory,
    required this.getTopUpHistory,
  }) : super(WalletInitial()) {
    on<TopUpEvent>(_onTopUp);
    on<GetTransactionHistoryEvent>(_onGetTransactionHistory);
    on<GetTopUpHistoryEvent>(_onGetTopUpHistory);
  }

  Future<void> _onTopUp(
    TopUpEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    
    final result = await topUp(TopUpParams(
      amount: event.amount,
      paymentMethod: event.paymentMethod,
      paymentMethodDetails: event.paymentMethodDetails,
    ));
    
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transaction) => emit(TopUpSuccess(transaction)),
    );
  }

  Future<void> _onGetTransactionHistory(
    GetTransactionHistoryEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    
    final result = await getTransactionHistory(GetTransactionHistoryParams(
      page: event.page,
      size: event.size,
    ));
    
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transactions) => emit(TransactionHistoryLoaded(transactions)),
    );
  }

  Future<void> _onGetTopUpHistory(
    GetTopUpHistoryEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    
    final result = await getTopUpHistory();
    
    result.fold(
      (failure) => emit(WalletError(failure.message)),
      (transactions) => emit(TopUpHistoryLoaded(transactions)),
    );
  }
}

