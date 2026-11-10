String formatNaira(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  final intPart = parts[0];
  final buf = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(',');
    buf.write(intPart[i]);
  }
  return '₦${buf.toString()}.${parts[1]}';
}
