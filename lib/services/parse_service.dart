class ParseService {
  /// Very simple parsing: tries to extract qty, product, and amount.
  static Map<String, dynamic> parseTransaction(String text) {
    final lower = text.toLowerCase();
    final qtyRegex = RegExp(r'(\d+)\s+(?:pieces|pcs|units|kgs|kg)?\s*(\w+)', multiLine: true);
    final priceRegex = RegExp(r'₹?\s?(\d{2,}(?:,\d{2,})*(?:\.\d+)?)');
    int qty = 1;
    String product = 'item';
    double? price;

    final qtyMatch = qtyRegex.firstMatch(lower);
    if (qtyMatch != null) {
      qty = int.tryParse(qtyMatch.group(1) ?? '1') ?? 1;
      product = qtyMatch.group(2) ?? 'item';
    }
    final priceMatch = priceRegex.firstMatch(lower);
    if (priceMatch != null) {
      final cleaned = priceMatch.group(1)!.replaceAll(',', '');
      price = double.tryParse(cleaned);
    }
    // if price is per item, total = qty * price
    return {
      'action': lower.contains('sold') ? 'sale' : (lower.contains('buy') ? 'purchase' : 'unknown'),
      'product': product,
      'qty': qty,
      'unitPrice': price,
      'total': price != null ? price * qty : null,
      'raw': text,
    };
  }
}
