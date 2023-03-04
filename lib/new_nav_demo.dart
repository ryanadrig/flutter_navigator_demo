import 'package:flutter/material.dart';
import 'package:navigator_demo/nav_push_demo.dart';

class NewNavRoot extends StatefulWidget {
  const NewNavRoot({Key? key}) : super(key: key);

  @override
  _NewNavRootState createState() => _NewNavRootState();
}

class _NewNavRootState extends State<NewNavRoot> {
  @override
  Widget build(BuildContext context) {
    return ProductsApp();
  }
}

List<Product> products = [
  Product('Fridge', 'Very Cold'),
  Product('Stove', 'Very Hot'),
  Product('Tree', 'Shipping costs may vary'),
];

class Product {
  final String name;
  final String desc;

  Product(this.name, this.desc);
}

class ProductsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductsAppState();
}

class _ProductsAppState extends State<ProductsApp> {
  ProductRouterDelegate _routerDelegate = ProductRouterDelegate();
  ProductRouteInformationParser _routeInformationParser =
  ProductRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Products App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class ProductRouteInformationParser extends RouteInformationParser<ProductRoutePath> {
  @override
  Future<ProductRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments[0] == "new_nav") {
      return ProductRoutePath.home();
    }

    if (uri.pathSegments[0] == "root"){
      return ProductRoutePath.exit_to_root();
    }


    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'product') return ProductRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return ProductRoutePath.unknown();
      return ProductRoutePath.details(id);
    }


    return ProductRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(ProductRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/new_nav');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/product/${path.id}');
    }
    return RouteInformation(location: '/404');
  }
}

class ProductRoutePath {
  int? id;
  final bool isUnknown;

  ProductRoutePath.exit_to_root():
      id = null,
      isUnknown = false;

  ProductRoutePath.home()
      : id = null,
        isUnknown = false;

  ProductRoutePath.details(this.id) : isUnknown = false;

  ProductRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}

class ProductRouterDelegate extends RouterDelegate<ProductRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ProductRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Product? _selectedProduct;
  bool show404 = false;
  bool exit_to_root = false;


  ProductRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  ProductRoutePath get currentConfiguration {
    if (show404) {
      return ProductRoutePath.unknown();
    }
    if (exit_to_root){
      return ProductRoutePath.exit_to_root();
    }
    return _selectedProduct == null
        ? ProductRoutePath.home()
        : ProductRoutePath.details(products.indexOf(_selectedProduct!));
  }

  @override
  Widget build(BuildContext context) {

    if (exit_to_root){
      return NavDemoRoot();
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: ValueKey('ProductsListPage'),
          child:
            ProductsListScreen(
            products: products,
            onTapped: _handleProductTapped,
              exit: _handleExitToRoot
          ),
        ),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedProduct != null)
          ProductDetailsPage(product: _selectedProduct!)
      ],
      onPopPage: (route, result) {
        print("page pop");
        if (!route.didPop(result)) {
          return false;
        }

        _selectedProduct = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ProductRoutePath path) async {
    if (path.isUnknown) {
      _selectedProduct = null;
      show404 = true;
      return;
    }

    if (exit_to_root){
      return;
    }

    if (path.isDetailsPage) {
      if (path.id! < 0 || path.id! > products.length - 1) {
        show404 = true;
        return;
      }

      _selectedProduct = products[path.id!];
    } else {
      _selectedProduct = null;
    }

    show404 = false;
  }

  void _handleExitToRoot(code){
    exit_to_root = true;
    notifyListeners();
  }

  void _handleProductTapped(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }
}

class ProductDetailsPage extends Page {
  final Product product;

  ProductDetailsPage({
    required this.product,
  }) : super(key: ValueKey(product));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return    ProductDetailsScreen(product: product);
      },
    );
  }
}



class ProductsListScreen extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onTapped;
  final ValueChanged exit;

  ProductsListScreen({
    required this.products,
    required this.onTapped,
    required this.exit
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title:
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){
             exit(0);
            },

          ),),
      body: ListView(
        children: [
          for (var product in products)
            ListTile(
              title: Text(product.name),
              subtitle: Text(product.desc),
              onTap: () => onTapped(product),
            )
        ],
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product != null) ...[
              Text(product.name, style: Theme.of(context).textTheme.headline6),
              Text(product.desc, style: Theme.of(context).textTheme.subtitle1),
            ],
          ],
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404, Page not found'),
      ),
    );
  }
}