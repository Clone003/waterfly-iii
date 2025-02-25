import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import 'package:waterflyiii/generated/swagger_fireflyiii_api/firefly_iii.swagger.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

extension CurrencyFormat on CurrencyRead {
  String fmt(
    num amount, {
    String? locale,
    bool forceCode = false,
    int? decimalDigits,
  }) =>
      NumberFormat.currency(
        locale: locale ?? Intl.defaultLocale,
        name: attributes.code,
        decimalDigits: decimalDigits ?? attributes.decimalPlaces,
        symbol: forceCode ? null : attributes.symbol,
      ).format(amount);

  String zero({String? locale}) => NumberFormat.currency(
        locale: locale ?? Intl.defaultLocale,
        name: "",
        symbol: "",
        decimalDigits: attributes.decimalPlaces,
      ).format(0);
}

extension AccountRole on AccountRoleProperty {
  String friendlyName(BuildContext context) {
    switch (this) {
      case AccountRoleProperty.cashwalletasset:
        return S.of(context).accountRoleAssetCashWallet;
      case AccountRoleProperty.ccasset:
        return S.of(context).accountRoleAssetCC;
      case AccountRoleProperty.defaultasset:
        return S.of(context).accountRoleAssetDefault;
      case AccountRoleProperty.savingasset:
        return S.of(context).accountRoleAssetSavings;
      case AccountRoleProperty.sharedasset:
        return S.of(context).accountRoleAssetShared;
      default:
        return S.of(context).generalUnknown;
    }
  }
}

extension TransactionType on TransactionTypeProperty {
  Color get color {
    switch (this) {
      case TransactionTypeProperty.deposit:
        return Colors.green;

      case TransactionTypeProperty.withdrawal:
        return Colors.red;

      case TransactionTypeProperty.transfer:
        return Colors.blue;
      // reconciliation
      // openingBalance
      default:
        return Colors.black;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionTypeProperty.deposit:
        return Icons.arrow_forward;

      case TransactionTypeProperty.withdrawal:
        return Icons.arrow_back;

      case TransactionTypeProperty.transfer:
        return Icons.swap_horiz;
      // reconciliation
      // openingBalance
      default:
        return Icons.question_mark;
    }
  }

  // Taken from Web Interface
  // Deposit: Asset%20account,Revenue%20account,Loan,Debt,Mortgage
  // Withdrawal: Asset%20account,Loan,Debt,Mortgage
  // Transfer: Asset%20account,Revenue%20account,Loan,Debt,Mortgage
  List<AccountTypeFilter> get sourceAccountTypes {
    switch (this) {
      case TransactionTypeProperty.withdrawal:
        return <AccountTypeFilter>[
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.deposit:
        return <AccountTypeFilter>[
          AccountTypeFilter.revenueAccount,
          AccountTypeFilter.cashAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.transfer:
        return <AccountTypeFilter>[
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.openingBalance:
        return <AccountTypeFilter>[
          AccountTypeFilter.initialBalanceAccount,
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.reconciliation:
        return <AccountTypeFilter>[
          AccountTypeFilter.reconciliationAccount,
          AccountTypeFilter.assetAccount,
        ];
      /*case TransactionTypeProperty.liabilityCredit:
        return <AccountTypeFilter>[
          AccountTypeFilter.liabilityCreditAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];*/

      default:
        return <AccountTypeFilter>[
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.expenseAccount,
          AccountTypeFilter.revenueAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
    }
  }

  // Withdrawal: Expense%20account,Cash%20account,Loan,Debt,Mortgage
  // Deposit: Asset%20account,Expense%20account,Loan,Debt,Mortgage
  // Transfer: Asset%20account,Expense%20account,Loan,Debt,Mortgage
  List<AccountTypeFilter> get destinationAccountTypes {
    switch (this) {
      case TransactionTypeProperty.withdrawal:
        return <AccountTypeFilter>[
          AccountTypeFilter.expenseAccount,
          AccountTypeFilter.cashAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.deposit:
        return <AccountTypeFilter>[
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.transfer:
        return <AccountTypeFilter>[
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.openingBalance:
        return <AccountTypeFilter>[
          AccountTypeFilter.initialBalanceAccount,
          AccountTypeFilter.assetAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];
      case TransactionTypeProperty.reconciliation:
        return <AccountTypeFilter>[
          AccountTypeFilter.reconciliationAccount,
          AccountTypeFilter.assetAccount,
        ];
      /*case TransactionTypeProperty.liabilityCredit:
        return <AccountTypeFilter>[
          AccountTypeFilter.liabilityCreditAccount,
          AccountTypeFilter.loan,
          AccountTypeFilter.debt,
          AccountTypeFilter.mortgage,
        ];*/

      default:
        return <AccountTypeFilter>[
          AccountTypeFilter.all,
        ];
    }
  }

  List<AccountTypeFilter> allowedSourceDests(AccountTypeFilter sourceAccount) {
    switch (this) {
      case TransactionTypeProperty.withdrawal:
        switch (sourceAccount) {
          case AccountTypeFilter.assetAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.expenseAccount,
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
              AccountTypeFilter.cashAccount
            ];
          case AccountTypeFilter.loan:
          case AccountTypeFilter.debt:
          case AccountTypeFilter.mortgage:
            return <AccountTypeFilter>[
              AccountTypeFilter.expenseAccount,
              AccountTypeFilter.cashAccount,
            ];
          default:
            return <AccountTypeFilter>[];
        }
      case TransactionTypeProperty.deposit:
        switch (sourceAccount) {
          case AccountTypeFilter.revenueAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.assetAccount,
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
            ];
          case AccountTypeFilter.cashAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.assetAccount,
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
            ];
          case AccountTypeFilter.loan:
          case AccountTypeFilter.debt:
          case AccountTypeFilter.mortgage:
            return <AccountTypeFilter>[
              AccountTypeFilter.assetAccount,
            ];
          default:
            return <AccountTypeFilter>[];
        }
      case TransactionTypeProperty.transfer:
        switch (sourceAccount) {
          case AccountTypeFilter.assetAccount:
            return <AccountTypeFilter>[AccountTypeFilter.assetAccount];
          case AccountTypeFilter.loan:
          case AccountTypeFilter.debt:
          case AccountTypeFilter.mortgage:
            return <AccountTypeFilter>[
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
            ];
          default:
            return <AccountTypeFilter>[];
        }
      case TransactionTypeProperty.openingBalance:
        switch (sourceAccount) {
          case AccountTypeFilter.assetAccount:
          case AccountTypeFilter.loan:
          case AccountTypeFilter.debt:
          case AccountTypeFilter.mortgage:
            return <AccountTypeFilter>[AccountTypeFilter.initialBalanceAccount];
          case AccountTypeFilter.initialBalanceAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.assetAccount,
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
            ];
          default:
            return <AccountTypeFilter>[];
        }
      case TransactionTypeProperty.reconciliation:
        switch (sourceAccount) {
          case AccountTypeFilter.reconciliationAccount:
            return <AccountTypeFilter>[AccountTypeFilter.assetAccount];
          case AccountTypeFilter.assetAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.reconciliationAccount,
            ];
          default:
            return <AccountTypeFilter>[];
        }
      /*case TransactionTypeProperty.liabilityCredit:
        switch (sourceAccount) {
          case AccountTypeFilter.assetAccount:
          case AccountTypeFilter.loan:
          case AccountTypeFilter.debt:
          case AccountTypeFilter.mortgage:
            return <AccountTypeFilter>[
              AccountTypeFilter.liabilityCreditAccount,
            ];
          case AccountTypeFilter.liabilityCreditAccount:
            return <AccountTypeFilter>[
              AccountTypeFilter.loan,
              AccountTypeFilter.debt,
              AccountTypeFilter.mortgage,
            ];
          default:
            return <AccountTypeFilter>[];
        }*/

      default:
        return <AccountTypeFilter>[
          AccountTypeFilter.all,
        ];
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime setTimeOfDay(TimeOfDay time) => DateTime(
        year,
        month,
        day,
        time.hour,
        time.minute,
      );

  DateTime setTime({
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliSeconds = 0,
    int microSeconds = 0,
  }) =>
      DateTime(
        year,
        month,
        day,
        hours,
        minutes,
        seconds,
        milliSeconds,
        microSeconds,
      );

  DateTime clearTime() => DateTime(year, month, day, 0, 0, 0, 0, 0);

  TimeOfDay getTimeOfDay() => TimeOfDay.fromDateTime(this);
}

extension ListStringIgnoreCase on List<String> {
  bool containsIgnoreCase(String? element) {
    for (String e in this) {
      if (e.toLowerCase() == element?.toLowerCase()) return true;
    }
    return false;
  }
}

extension StringIgnoreCase on String {
  bool containsIgnoreCase(String? a) =>
      a == null || toLowerCase().contains(a.toLowerCase());
}

extension AccountTypeFilterIcon on AccountTypeFilter {
  IconData icon() {
    switch (this) {
      case AccountTypeFilter.asset:
        return Icons.money_outlined;
      case AccountTypeFilter.expense:
        return Icons.shopping_cart;
      case AccountTypeFilter.revenue:
        return Icons.download;
      case AccountTypeFilter.liabilities:
        return Icons.payment_outlined;
      default:
        return Icons.question_mark;
    }
  }

  String friendlyName(BuildContext context) {
    switch (this) {
      case AccountTypeFilter.asset:
        return S.of(context).accountsLabelAsset;
      case AccountTypeFilter.expense:
        return S.of(context).accountsLabelExpense;
      case AccountTypeFilter.revenue:
        return S.of(context).accountsLabelRevenue;
      case AccountTypeFilter.liabilities:
        return S.of(context).accountsLabelLiabilities;
      default:
        return S.of(context).generalAccount;
    }
  }
}
