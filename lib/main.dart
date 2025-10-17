import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'models/product.dart';
import 'models/order.dart';
import 'data/fake_products.dart';
import 'pages/home_page.dart';
import 'pages/cart_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/orders_page.dart';
import 'pages/profile_page.dart';
// New imports for authentication pages
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgotpass_page.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Import for authentication state management
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AgriShopApp());
}

class AgriShopApp extends StatefulWidget {
  const AgriShopApp({Key? key}) : super(key: key);

  @override
  State<AgriShopApp> createState() => _AgriShopAppState();
}

class _AgriShopAppState extends State<AgriShopApp> {
  final Cart _cart = Cart();
  final List<Product> _products = FakeProducts.all;
  final List<Order> _orders = [];
  int _currentIndex = 0;

  void _addToCart(Product product, {int quantity = 1}) {
    setState(() {
      _cart.add(product, quantity: quantity);
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      _cart.remove(product);
    });
  }

  void _updateQuantity(Product product, int quantity) {
    setState(() {
      _cart.updateQuantity(product, quantity);
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  void _placeOrder(DeliveryDetails deliveryDetails) {
    if (_cart.items.isEmpty) return;

    final orderItems = _cart.items.values.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        price: cartItem.product.price,
        quantity: cartItem.quantity,
        imageUrl: cartItem.product.imageUrl,
      );
    }).toList();

    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      items: orderItems,
      subtotal: _cart.subtotal,
      shipping: _cart.shipping,
      total: _cart.total,
      status: 'Processing',
      deliveryDetails: deliveryDetails,
    );

    setState(() {
      _orders.insert(0, order);
      _cart.clear();
    });
  }

  void _onTabTapped(int index) {
    // Only pop if the current route is a product detail or cart page
    // and we're navigating within the main tabs (0, 1, 2)
    if (_currentIndex != index &&
        (ModalRoute.of(context)?.settings.name == '/cart' ||
            ModalRoute.of(context)?.settings.name == '/product')) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildMainNavigation() {
    final pages = [
      HomePage(products: _products, cart: _cart, onAddToCart: _addToCart),
      OrdersPage(orders: _orders),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriShop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4A7C2F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A7C2F),
        ).copyWith(secondary: const Color(0xFFFF6B35)),
        fontFamily: 'Montserrat',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2D5016),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF4A7C2F),
        ),
      ),
      // --- Authentication State Listener (The main fix) ---
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loading indicator while checking auth status
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;

          // If the user is logged in, show the main app navigation
          if (user != null) {
            return _buildMainNavigation();
          }

          // If the user is not logged in, show the login page
          return const LoginPage();
        },
      ),
      // ---------------------------------------------------
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // --- Authentication Routes ---
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());

          case '/signup':
            return MaterialPageRoute(builder: (context) => const SignUpPage());

          case '/forgotpass':
            return MaterialPageRoute(
              builder: (context) => const ForgotPasswordPage(),
            );

          // --- App Routes ---
          // The root route '/' is now handled by the 'home' property StreamBuilder
          case '/cart':
            return MaterialPageRoute(
              builder: (context) => CartPage(
                cart: _cart,
                onRemove: _removeFromCart,
                onUpdateQuantity: _updateQuantity,
                onClear: _clearCart,
                onPlaceOrder: _placeOrder,
              ),
            );

          case '/orders':
            return MaterialPageRoute(
              builder: (context) => OrdersPage(orders: _orders),
            );

          case '/product':
            final product = settings.arguments;
            if (product is Product) {
              return MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                  cart: _cart,
                  onAddToCart: _addToCart,
                  onUpdateQuantity: _updateQuantity,
                ),
              );
            }
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Error: Product not specified')),
              ),
            );

          default:
            // This is primarily for sub-routes called from within the app,
            // like Navigator.pushNamed(context, '/orders') from profile_page.dart
            return MaterialPageRoute(
              builder: (context) => _buildMainNavigation(),
            );
        }
      },
      // Removed initialRoute as 'home' property handles initial routing based on auth state
      // initialRoute: '/',
    );
  }
}
