class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final String paymentMethod;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    this.paymentMethod = 'Cash on Delivery',
  });

  double get lineTotal => price * quantity;
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String status;
  final DeliveryDetails deliveryDetails;
  final double discount;
  final String paymentMethod;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.deliveryDetails,
    this.discount = 0.0,
    this.paymentMethod = 'Cash on Delivery',
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class DeliveryDetails {
  final String fullName;
  final String phoneNumber;
  final String address;
  final String? notes;

  DeliveryDetails({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    this.notes,
  });
}
