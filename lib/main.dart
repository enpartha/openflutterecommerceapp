import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../data/repositories/abstract/favorites_repository.dart';
import '../data/model/filter_rules.dart';
import '../data/repositories/abstract/product_repository.dart';
import '../data/repositories/abstract/user_repository.dart';
import '../locator.dart';
import '../presentation/features/forget_password/forget_password_screen.dart';
import '../presentation/features/sign_in/sign_in.dart';
import '../presentation/features/filters/filters_screen.dart';
import '../presentation/features/product_details/product_screen.dart';
import '../presentation/features/products/products.dart';
import '../presentation/features/sign_in/signin_screen.dart';
import '../presentation/features/sign_up/signup_screen.dart';

import 'config/routes.dart';
import 'data/repositories/abstract/cart_repository.dart';
import 'data/repositories/abstract/category_repository.dart';
import 'presentation/features/authentication/authentication.dart';
import 'presentation/features/forget_password/forget_password.dart';
import 'presentation/features/sign_up/sign_up_bloc.dart';
import 'presentation/features/cart/cart.dart';
import 'presentation/features/categories/categories.dart';
import 'presentation/features/checkout/checkout.dart';
import 'presentation/features/favorites/favorites.dart';
import 'presentation/features/home/home.dart';
import 'presentation/features/profile/profile.dart';

import 'locator.dart' as service_locator;

class SimpleBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  await service_locator.init();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'de', 'fr'],
  );

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = SimpleBlocDelegate();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc()..add(AppStarted()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CategoryRepository?>(
            create: (context) => sl(),
          ),
          RepositoryProvider<ProductRepository?>(
            create: (context) => sl(),
          ),
          RepositoryProvider<FavoritesRepository?>(
            create: (context) => sl(),
          ),
          RepositoryProvider<UserRepository?>(
            create: (context) => sl(),
          ),
          RepositoryProvider<CartRepository?>(
            create: (context) => sl(),
          ),
        ],
        child: LocalizedApp(
          delegate,
          OpenFlutterEcommerceApp(),
        ),
      ),
    ),
  );
}

class OpenFlutterEcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate,
          ],
          onGenerateRoute: _registerRoutesWithParameters,
          supportedLocales: localizationDelegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          locale: localizationDelegate.currentLocale,
          title: 'Open FLutter E-commerce',
          theme: OpenFlutterEcommerceTheme.of(context),
          routes: _registerRoutes(),
        ));
  }

  Map<String, WidgetBuilder> _registerRoutes() {
    return <String, WidgetBuilder>{
      OpenFlutterEcommerceRoutes.home: (context) => HomeScreen(),
      OpenFlutterEcommerceRoutes.cart: (context) => CartScreen(),
      OpenFlutterEcommerceRoutes.checkout: (context) => CheckoutScreen(),
      OpenFlutterEcommerceRoutes.favourites: (context) => FavouriteScreen(),
      OpenFlutterEcommerceRoutes.signin: (context) => _buildSignInBloc(),
      OpenFlutterEcommerceRoutes.signup: (context) => _buildSignUpBloc(),
      OpenFlutterEcommerceRoutes.forgotPassword: (context) =>
          _buildForgetPasswordBloc(),
      OpenFlutterEcommerceRoutes.profile: (context) =>
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            //TODO: revise authentication later. Right now no login is required.
            /*if (state is Authenticated) {
              return ProfileScreen(); //TODO profile properties should be here
            } else if (state is Unauthenticated) {
              return _buildSignInBloc();
            } else {
              return SplashScreen();
            }*/
            return ProfileScreen();
          }),
    };
  }

  BlocProvider<ForgetPasswordBloc> _buildForgetPasswordBloc() {
    return BlocProvider<ForgetPasswordBloc>(
      create: (context) => ForgetPasswordBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: ForgetPasswordScreen(),
    );
  }

  BlocProvider<SignInBloc> _buildSignInBloc() {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignInScreen(),
    );
  }

  BlocProvider<SignUpBloc> _buildSignUpBloc() {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignUpScreen(),
    );
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    if (settings.name == OpenFlutterEcommerceRoutes.shop) {
      final CategoriesParameters? args = settings.arguments as CategoriesParameters?;
      return MaterialPageRoute(
        builder: (context) {
          return CategoriesScreen(
            parameters: args,
          );
        },
      );
    } else if (settings.name == OpenFlutterEcommerceRoutes.productList) {
      final ProductListScreenParameters? productListScreenParameters =
          settings.arguments as ProductListScreenParameters?;
      return MaterialPageRoute(builder: (context) {
        return ProductsScreen(
          parameters: productListScreenParameters,
        );
      });
    } else if (settings.name == OpenFlutterEcommerceRoutes.product) {
      final ProductDetailsParameters? parameters = settings.arguments as ProductDetailsParameters?;
      return MaterialPageRoute(builder: (context) {
        return ProductDetailsScreen(parameters);
      });
    } else if (settings.name == OpenFlutterEcommerceRoutes.filters) {
      final FilterRules? filterRules = settings.arguments as FilterRules?;
      return MaterialPageRoute(builder: (context) {
        return FiltersScreen(filterRules);
      });
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      );
    }
  }
}
