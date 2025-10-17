import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;
}

class Cart {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void add(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
  }

  void remove(Product product) {
    if (!_items.containsKey(product.id)) return;
    final item = _items[product.id]!;
    item.quantity -= 1;
    if (item.quantity <= 0) {
      _items.remove(product.id);
    }
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      _items.remove(product.id);
    } else if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity = quantity;
    }
  }

  void removeCompletely(Product product) {
    _items.remove(product.id);
  }

  void clear() {
    _items.clear();
  }

  int get totalQuantity {
    int sum = 0;
    for (final item in _items.values) {
      sum += item.quantity;
    }
    return sum;
  }

  double get subtotal {
    double sum = 0;
    for (final item in _items.values) {
      sum += item.lineTotal;
    }
    return sum;
  }

  double get shipping {
    return subtotal >= 100 ? 0.0 : (items.isEmpty ? 0.0 : 50.0);
  }

  double get total => subtotal + shipping;

  int getProductQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void removeItem(CartItem item) {}

  void addItem(Product product, int quantity) {}
}
