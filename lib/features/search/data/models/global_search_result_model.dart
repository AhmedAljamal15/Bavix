enum GlobalSearchResultType {
  customer,
  item,
  salesOrder,
  salesInvoice,
  deliveryNote,
}

class GlobalSearchResultModel {
  final GlobalSearchResultType type;
  final String id;
  final String title;
  final String subtitle;
  final String trailing;

  const GlobalSearchResultModel({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });
}
