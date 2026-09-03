import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paynow/bloc/auth/auth_bloc.dart';
import 'package:paynow/bloc/notification/notification_bloc.dart';
import 'package:paynow/bloc/payment/payment_bloc.dart';
import 'package:paynow/bloc/profile/profile_bloc.dart';
import 'package:paynow/bloc/transaction/transaction_bloc.dart';
import 'package:paynow/bloc/wallet/wallet_bloc.dart';
import 'package:paynow/bloc/auth/auth_state.dart';
import 'package:paynow/screen/home/main_screen.dart';
import 'package:paynow/screen/auth/login_screen.dart';
import 'package:paynow/hive/hive_service.dart';
import 'package:paynow/utils/app_constants.dart';
import 'package:paynow/utils/app_theme.dart';
import 'package:paynow/bloc/theme/theme_bloc.dart';
import 'package:paynow/bloc/theme/theme_state.dart';
import 'package:paynow/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database and encrypted secure storage
  await HiveService.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light, // For iOS
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<WalletBloc>(
          create: (_) => WalletBloc(),
        ),
        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc(),
        ),
        BlocProvider<PaymentBloc>(
          create: (_) => PaymentBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            onGenerateRoute: AppRouter.generateRoute,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            ),
            builder: (context, child) {
              final mediaQueryData = MediaQuery.of(context);
              final double screenWidth = mediaQueryData.size.width;
              final double effectiveWidth = screenWidth.clamp(0.0, 600.0);
              final scale = (effectiveWidth / 375.0).clamp(0.85, 1.25);
              
              Widget appContent = child!;
              
              if (screenWidth > 600) {
                appContent = Container(
                  color: const Color(0xFF1E293B), // Sleek slate outer background
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: appContent,
                      ),
                    ),
                  ),
                );
              }
              
              return MediaQuery(
                data: mediaQueryData.copyWith(
                  size: Size(effectiveWidth, mediaQueryData.size.height),
                  textScaler: TextScaler.linear(scale),
                ),
                child: appContent,
              );
            },
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthSuccess) {
                  return const MainScreen();
                }
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

