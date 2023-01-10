import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'constants.dart';
import 'login_state.dart';
import 'ui/create_account.dart';
import 'ui/details.dart';
import 'ui/error_page.dart';
import 'ui/home_screen.dart';
import 'ui/login.dart';
import 'ui/more_info.dart';
import 'ui/payment.dart';
import 'ui/personal_info.dart';
import 'ui/signin_info.dart';

class MyRouter {
  final LoginState loginState;

  MyRouter(this.loginState);

  late final router = GoRouter(
    // path, error handler, redirect
    initialLocation: '/login',
    errorBuilder: (context, state) {
      return ErrorPage(error: state.error);
    },
    // errorPageBuilder: (context, state) {
    //   return MaterialPage<void>(child: ErrorPage());
    // },
    routes: [
      GoRoute(
        path: '/login',
        name: loginRouteName,
        builder: (context, state) {
          return const Login();
        },
      ),
      GoRoute(
        path: '/create-account',
        name: createAccountRouteName,
        builder: (context, state) {
          return const CreateAccount();
        },
      ),
      GoRoute(
        path: '/:tab',
        name: rootRouteName,
        builder: (context, state) {
          final tab = state.params['tab'];
          debugPrint('tab is $tab');
          // return HomeScreen(tab: 'shopping');
          return HomeScreen(tab: tab ?? '');
        },
        routes: [
          GoRoute(
            path: 'details/:item', // '/' 없이 입력할 것. 실제주소창에 표시되고 go 라우팅시 매칭확인
            name: shopDetailsRouteName, // Named 라우팅할때 매칭확인
            builder: (context, state) {
              final item = state.params['item'];
              return Details(description: item!);
            },
          ),
          GoRoute(
            path: 'profile-personal', // '/' 없이 입력할 것.
            name: profilePersonalRouteName,
            builder: (context, state) {
              return const PersonalInfo();
            },
          ),
          GoRoute(
            path: profilePaymentRouteName, // '/' 없이 입력할 것.
            name: profilePaymentRouteName,
            builder: (context, state) {
              return const Payment();
            },
          ),
          GoRoute(
            path: profileSigninInfoRouteName, // '/' 없이 입력할 것.
            name: profileSigninInfoRouteName,
            builder: (context, state) {
              return const SigninInfo();
            },
          ),
          GoRoute(
            path: profileMoreInfoRouteName, // '/' 없이 입력할 것.
            name: profileMoreInfoRouteName,
            builder: (context, state) {
              return const MoreInfo();
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final loggedIn = loginState.loggedIn;
      final inAuthPages = state.subloc.contains(loginRouteName) ||
          state.subloc.contains(createAccountRouteName);
      //inAuth && true => go to home
      if (inAuthPages && loggedIn) return '/cart';
      //notInAuth && false => go to loginPage
      if (!inAuthPages && !loggedIn) return '/login';
      //inAuth && false => stay inAuthPages(loginPage or createPage)
    },
    refreshListenable: loginState,
    debugLogDiagnostics: true, // false when you release the app.
  );
}
