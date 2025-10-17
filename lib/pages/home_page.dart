import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final List<Product> products;
  final Cart cart;
  final void Function(Product) onAddToCart;

  const HomePage({
    Key? key,
    required this.products,
    required this.cart,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cartBadgeController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cartBadgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );

    _headerController.forward();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cart.totalQuantity != widget.cart.totalQuantity) {
      _cartBadgeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cartBadgeController.dispose();
    super.dispose();
  }

  void _openCart(BuildContext context) {
    Navigator.pushNamed(context, '/cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.agriculture, size: 28),
            SizedBox(width: 8),
            Text(
              'PalaConnect',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          _AnimatedCartButton(
            cart: widget.cart,
            onPressed: () => _openCart(context),
            controller: _cartBadgeController,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Animated Header Banner
          FadeTransition(
            opacity: _headerAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.2),
                end: Offset.zero,
              ).animate(_headerAnimation),
              child: _HeaderBanner(),
            ),
          ),

          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.storefront,
                  color: Color(0xFF4A7C2F),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Available Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5016),
                  ),
                ),
                const Spacer(),
                TweenAnimationBuilder(
                  tween: IntTween(begin: 0, end: widget.products.length),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, int value, child) {
                    return Text(
                      '$value items',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    );
                  },
                ),
              ],
            ),
          ),

          // Animated Products Grid
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: GridView.builder(
                key: ValueKey(widget.products.length),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return _AnimatedProductCard(
                    product: product,
                    index: index,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product',
                        arguments: product,
                      );
                    },
                    onAddToCart: () {
                      widget.onAddToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('${product.name} added to basket'),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF4A7C2F),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Cart Button
class _AnimatedCartButton extends StatelessWidget {
  final Cart cart;
  final VoidCallback onPressed;
  final AnimationController controller;

  const _AnimatedCartButton({
    required this.cart,
    required this.onPressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.shopping_basket, size: 28),
          tooltip: 'View Basket',
        ),
        if (cart.totalQuantity > 0)
          Positioned(
            right: 8,
            top: 8,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.elasticOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  cart.totalQuantity > 99
                      ? '99+'
                      : cart.totalQuantity.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Animated Header Banner
class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A7C2F), Color(0xFF66A03B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.wb_sunny,
                      color: Colors.yellow[300],
                      size: 32,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Fresh from the Farm',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Quality produce directly from local farmers',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _InfoCard(icon: Icons.eco, label: 'Organic', delay: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.local_shipping,
                  label: 'Fast Delivery',
                  delay: 100,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  icon: Icons.verified,
                  label: 'Fresh',
                  delay: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Animated Info Card
class _InfoCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int delay;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.delay,
  });

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(widget.icon, color: Colors.white, size: 26),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Product Card
class _AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _AnimatedProductCard({
    required this.product,
    required this.index,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<_AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<_AnimatedProductCard>
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
      begin: const Offset(0, 0.3),
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
          child: ProductCard(
            product: widget.product,
            onTap: widget.onTap,
            onAddToCart: widget.onAddToCart,
          ),
        ),
      ),
    );
  }
}
