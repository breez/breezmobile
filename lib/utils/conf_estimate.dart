String formatConfirmationTime(int blocks) {
  if (blocks <= 2) {
    blocks = 1;
  }
  String estimatedDelivery = "${blocks * 10} minutes";
  var hours = blocks / 6;
  if (hours == 1.0) {
    estimatedDelivery = "${hours.ceil()} hour";
  }
  if (hours > 1.0) {
    estimatedDelivery = "${hours.ceil()} hours";
  }
  return estimatedDelivery;
}
