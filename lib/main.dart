import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'index.dart';
import 'backend/backend.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed (Running in Mock Mode): $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'NavBarPage',
      builder: (BuildContext context, GoRouterState state) {
        final rawPage = state.uri.queryParameters['page'] ?? 'HomePage';
        final vendedorID = state.uri.queryParameters['vendedorID'] ?? 'vendedor_component';
        
        String initialPage = 'HomePage';
        if (rawPage == 'CartPage' || rawPage == 'Carrito' || rawPage == 'cart' || rawPage == 'carrito') {
          initialPage = 'CartPage';
        }
        
        Widget? targetPage;
        if (initialPage == 'HomePage') {
          targetPage = HomePageWidget(vendedorID: vendedorID);
        } else if (initialPage == 'CartPage') {
          targetPage = const CartPageWidget();
        }
        
        return NavBarPage(initialPage: initialPage, page: targetPage, vendedorID: vendedorID);
      },
    ),
    GoRoute(
      path: '/productsPage',
      name: ProductsPageWidget.routeName,
      builder: (BuildContext context, GoRouterState state) {
        final vendedorID = state.uri.queryParameters['vendedorID'] ?? 'vendedor_component';
        final categoriaRef = state.uri.queryParameters['categoriaRef'] ?? '';
        return ProductsPageWidget(vendedorID: vendedorID, categoriaRef: categoriaRef);
      },
    ),
    GoRoute(
      path: '/productDetailPage',
      name: ProductDetailPageWidget.routeName,
      builder: (BuildContext context, GoRouterState state) {
        final productoDoc = state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['productoDoc'] as ProductosRecord?
            : state.extra as ProductosRecord?;
        if (productoDoc == null) {
          return const Scaffold(body: Center(child: Text('Error loading product details')));
        }
        return ProductDetailPageWidget(productoDoc: productoDoc);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Component New House',
      theme: ThemeData(
        primaryColor: FlutterFlowTheme.of(context).primary,
        scaffoldBackgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        useMaterial3: true,
      ),
      routerConfig: _router,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isWide = screenWidth > 450;
        final double width = isWide ? 450 : screenWidth;

        final constrainedChild = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            size: Size(width, screenHeight),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: isWide
                  ? const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    )
                  : null,
              child: child,
            ),
          ),
        );

        if (isWide) {
          return Container(
            color: const Color(0xFF1E293B), // Slate gray background for desktop
            child: constrainedChild,
          );
        }
        return child!;
      },
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page, this.vendedorID});

  final String? initialPage;
  final Widget? page;
  final String? vendedorID;

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _page;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _page = widget.page;
  }

  @override
  void didUpdateWidget(NavBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPage != oldWidget.initialPage || widget.page != oldWidget.page) {
      setState(() {
        _currentPageName = widget.initialPage ?? 'HomePage';
        _page = widget.page;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': HomePageWidget(vendedorID: widget.vendedorID),
      'CartPage': const CartPageWidget(),
    };
    final currentIndex = _currentPageName == 'CartPage' ? 2 : 1;

    return Scaffold(
      body: _page ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) async {
          if (i == 0) {
            await launchURL('https://www.instagram.com/component_yz');
          } else {
            setState(() {
              _page = null;
              _currentPageName = i == 1 ? 'HomePage' : 'CartPage';
            });
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt_rounded),
            label: 'Instagram',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Carrito',
          ),
        ],
      ),
    );
  }
}
