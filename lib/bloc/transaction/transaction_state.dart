import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<Map<String, dynamic>> allTransactions;
  final List<Map<String, dynamic>> filteredTransactions;
  final List<Map<String, String>> bankRecipients;
  final List<Map<String, String>> upiRecipients;
  final String selectedFilter;
  final String searchQuery;

  const TransactionLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.bankRecipients,
    required this.upiRecipients,
    this.selectedFilter = 'All',
    this.searchQuery = '',
  });

  TransactionLoaded copyWith({
    List<Map<String, dynamic>>? allTransactions,
    List<Map<String, dynamic>>? filteredTransactions,
    List<Map<String, String>>? bankRecipients,
    List<Map<String, String>>? upiRecipients,
    String? selectedFilter,
    String? searchQuery,
  }) {
    return TransactionLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      bankRecipients: bankRecipients ?? this.bankRecipients,
      upiRecipients: upiRecipients ?? this.upiRecipients,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allTransactions,
        filteredTransactions,
        bankRecipients,
        upiRecipients,
        selectedFilter,
        searchQuery,
      ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
