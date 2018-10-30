class HistoryModel {
  final DateTime date;
  final String amount;
  final String reading;
  final String billType;
  final String historyAssetPath;

  HistoryModel(this.date, this.amount, this.reading, this.billType,
      this.historyAssetPath);
}
