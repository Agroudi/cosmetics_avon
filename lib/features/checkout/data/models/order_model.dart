class OrderModel {
  final int id;
  final String date;
  final double total;
  final String status; // 'pending', 'processing', 'completed', 'cancelled'
  final String address;
  final String paymentMethod;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      address: json['address'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Cash on Delivery',
      items: json['items'] != null
          ? List<OrderItemModel>.from(
              json['items'].map((x) => OrderItemModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'status': status,
      'address': address,
      'payment_method': paymentMethod,
      'items': List<dynamic>.from(items.map((x) => x.toJson())),
    };
  }
}

class OrderItemModel {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
