import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../models/order.dart';

class CartPage extends StatefulWidget {
  final Cart cart;
  final void Function(Product) onRemove;
  final void Function(Product, int) onUpdateQuantity;
  final VoidCallback onClear;
  final void Function(DeliveryDetails) onPlaceOrder;

  const CartPage({
    Key? key,
    required this.cart,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onClear,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _showCheckoutForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.local_shipping,
                          color: Color(0xFF4A7C2F),
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Delivery Details',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _AnimatedFormField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person,
                      delay: 0,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _AnimatedFormField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      delay: 100,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _AnimatedFormField(
                      controller: addressController,
                      label: 'Delivery Address',
                      icon: Icons.location_on,
                      maxLines: 3,
                      delay: 200,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your delivery address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _AnimatedFormField(
                      controller: notesController,
                      label: 'Delivery Notes (Optional)',
                      icon: Icons.note,
                      maxLines: 2,
                      delay: 300,
                      hintText: 'e.g., Leave at door, gate code, etc.',
                    ),
                    const SizedBox(height: 24),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  final deliveryDetails = DeliveryDetails(
                                    fullName: nameController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                    address: addressController.text.trim(),
                                    notes: notesController.text.trim().isEmpty
                                        ? null
                                        : notesController.text.trim(),
                                  );
                                  Navigator.pop(context);
                                  _confirmOrder(context, deliveryDetails);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Continue to Payment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder(BuildContext context, DeliveryDetails deliveryDetails) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: const [
                  Icon(Icons.check_circle, color: Color(0xFF4A7C2F), size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Order Placed!',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thank you for supporting local farmers!',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    builder: (context, double val, child) {
                      return Opacity(
                        opacity: val,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[50]!, Colors.green[100]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '₱${widget.cart.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A7C2F),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.local_shipping,
                                          color: Color(0xFF4A7C2F),
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Delivering to:',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      deliveryDetails.fullName,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      deliveryDetails.phoneNumber,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      deliveryDetails.address,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onPlaceOrder(deliveryDetails);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C2F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shopping_basket, size: 24),
            SizedBox(width: 8),
            Text('My Basket', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: const [
                        Icon(Icons.delete_sweep, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Clear Basket'),
                      ],
                    ),
                    content: const Text(
                      'Are you sure you want to remove all items from your basket?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onClear();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear basket',
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_basket_outlined,
                              size: 80,
                              color: Colors.green[300],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Your basket is empty',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add some fresh produce to get started',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.storefront),
                            label: const Text('Browse Products'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.green[50],
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: const Color(0xFF4A7C2F),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      TweenAnimationBuilder(
                        tween: IntTween(begin: 0, end: items.length),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, int value, child) {
                          return Text(
                            '$value ${value == 1 ? 'item' : 'items'} in basket',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C2F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TweenAnimationBuilder(
                          tween: IntTween(
                            begin: 0,
                            end: widget.cart.totalQuantity,
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, int value, child) {
                            return Text(
                              '$value total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _AnimatedCartItemCard(
                        item: item,
                        index: index,
                        onRemove: () => widget.onRemove(item.product),
                        onUpdateQuantity: (qty) =>
                            widget.onUpdateQuantity(item.product, qty),
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text('Remove Item'),
                              content: Text(
                                'Remove ${item.product.name} from basket?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    widget.cart.removeCompletely(item.product);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                _CartSummary(
                  cart: widget.cart,
                  onCheckout: () => _showCheckoutForm(context),
                ),
              ],
            ),
    );
  }
}

// Animated Form Field
class _AnimatedFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int delay;
  final int maxLines;
  final TextInputType keyboardType;
  final String? hintText;
  final String? Function(String?)? validator;

  const _AnimatedFormField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.delay,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.validator,
  });

  @override
  State<_AnimatedFormField> createState() => _AnimatedFormFieldState();
}

class _AnimatedFormFieldState extends State<_AnimatedFormField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _controller,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused ? const Color(0xFF4A7C2F) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() => _isFocused = hasFocus);
            },
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              validator: widget.validator,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hintText,
                prefixIcon: Icon(
                  widget.icon,
                  color: _isFocused
                      ? const Color(0xFF4A7C2F)
                      : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF4A7C2F),
                    width: 2,
                  ),
                ),
                alignLabelWithHint: widget.maxLines > 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Cart Item Card
class _AnimatedCartItemCard extends StatefulWidget {
  final CartItem item;
  final int index;
  final VoidCallback onRemove;
  final void Function(int) onUpdateQuantity;
  final VoidCallback onDelete;

  const _AnimatedCartItemCard({
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onDelete,
  });

  @override
  State<_AnimatedCartItemCard> createState() => _AnimatedCartItemCardState();
}

class _AnimatedCartItemCardState extends State<_AnimatedCartItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green[100]!, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Hero(
                    tag: 'product-${widget.item.product.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[100]!, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.item.product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.green[50],
                              child: const Icon(
                                Icons.eco,
                                color: Color(0xFF4A7C2F),
                                size: 32,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.item.product.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₱${widget.item.product.price.toStringAsFixed(2)} each',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        TweenAnimationBuilder(
                          tween: Tween<double>(
                            begin: 0,
                            end: widget.item.lineTotal,
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, double value, child) {
                            return Text(
                              '₱${value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A7C2F),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onRemove,
                                borderRadius: BorderRadius.circular(8),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: Color(0xFF4A7C2F),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Container(
                                key: ValueKey(widget.item.quantity),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  '${widget.item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D5016),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => widget.onUpdateQuantity(
                                  widget.item.quantity + 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: Color(0xFF4A7C2F),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: Colors.red[50],
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: widget.onDelete,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final Cart cart;
  final VoidCallback onCheckout;

  const _CartSummary({required this.cart, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.receipt_long,
                          color: Color(0xFF4A7C2F),
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '₱${cart.subtotal.toStringAsFixed(2)}',
                      isTotal: false,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Delivery Fee',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        if (cart.shipping == 0 && cart.subtotal >= 100)
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            builder: (context, double val, child) {
                              return Transform.scale(
                                scale: val,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green[400]!,
                                        Colors.green[600]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.local_shipping,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'FREE',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        else
                          Text(
                            '₱${cart.shipping.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 15),
                          ),
                      ],
                    ),
                    if (cart.subtotal < 100 && cart.subtotal > 0) ...[
                      const SizedBox(height: 12),
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double val, child) {
                          return Opacity(
                            opacity: val,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.orange[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: Colors.orange[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Add ₱${(100 - cart.subtotal).toStringAsFixed(2)} more for FREE delivery',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const Divider(height: 24, thickness: 1.5),
                    _SummaryRow(
                      label: 'Total Amount',
                      value: '₱${cart.total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onCheckout,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle_outline, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2D5016) : Colors.black87,
            ),
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          builder: (context, double val, child) {
            return Opacity(
              opacity: val,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: isTotal ? 22 : 15,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                  color: isTotal ? const Color(0xFF4A7C2F) : Colors.black87,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
