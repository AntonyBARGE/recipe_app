import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'pages/meals/meals_page.dart';
import 'pages/settings/settings_controller.dart';
import 'pages/settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  }) : router = GoRouter(
          restorationScopeId: 'app',
          debugLogDiagnostics: true,
          initialLocation: MealsPage.routeName,
          // extraCodec: const ExtraCodec(),
          routes: [
            GoRoute(
              path: MealsPage.routeName,
              name: MealsPage.routeName,
              builder: (context, state) => MealsPage(),
              // routes: [
              //   GoRoute(
              //     path: MealsPage.routeName,
              //     name: MealsPage.routeName,
              //     builder: (context, state) => MealsPage(),
              //   ),
              // ],
            ),
            GoRoute(
              path: SettingsView.routeName,
              name: SettingsView.routeName,
              builder: (context, state) =>
                  SettingsView(controller: settingsController),
            ),
            // StatefulShellRoute.indexedStack(
            //     builder: (context, state, navigationShell) => MultiBlocProvider(
            //           providers: [
            //             BlocProvider<ActivitiesBloc>(
            //               create: (_) => ActivitiesBloc(),
            //             ),
            //             BlocProvider<MediasBloc>(
            //               create: (_) => MediasBloc(),
            //             ),
            //             BlocProvider<PdfBloc>(
            //               create: (_) => PdfBloc(),
            //             ),
            //           ],
            //           child: ScaffoldWithNavBar(navigationShell: navigationShell),
            //         ),
            //     branches: [
            //       StatefulShellBranch(
            //         routes: <RouteBase>[
            //           GoRoute(
            //             path: RoutePath.home.key,
            //             name: RoutePath.home.key,
            //             builder: (context, state) {
            //               return HomeScreen();
            //             },
            //             routes: [
            //               GoRoute(
            //                 path: RoutePath.activity.key,
            //                 name: RoutePath.activity.key,
            //                 builder: (context, state) => ActivityDetailsScreen(
            //                   activity: state.extra as ActivityEntity,
            //                 ),
            //               ),
            //               GoRoute(
            //                 path: RoutePath.pdf.key,
            //                 name: RoutePath.pdf.key,
            //                 builder: (context, state) => PDFScreen(
            //                   path: state.extra as String,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //       StatefulShellBranch(
            //         routes: <RouteBase>[
            //           GoRoute(
            //             path: RoutePath.catalog.key,
            //             name: RoutePath.catalog.key,
            //             builder: (context, state) => const CatalogScreen(),
            //           ),
            //         ],
            //       ),
            //       StatefulShellBranch(
            //         routes: <RouteBase>[
            //           GoRoute(
            //             path: RoutePath.configurator.key,
            //             name: RoutePath.configurator.key,
            //             builder: (context, state) => const CatalogScreen(),
            //           ),
            //         ],
            //       ),
            //       StatefulShellBranch(
            //         routes: <RouteBase>[
            //           GoRoute(
            //             path: RoutePath.meeting.key,
            //             name: RoutePath.meeting.key,
            //             builder: (context, state) => const CatalogScreen(),
            //           ),
            //         ],
            //       ),
            //       StatefulShellBranch(
            //         routes: <RouteBase>[
            //           GoRoute(
            //             path: RoutePath.customerService.key,
            //             name: RoutePath.customerService.key,
            //             builder: (context, state) => const CatalogScreen(),
            //           ),
            //         ],
            //       ),
            //     ]),
          ],
        );

  final SettingsController settingsController;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',
            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsController.themeMode,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            routerConfig: router,
            builder: (context, child) => child!,
          );
        },
      ),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFB14BA8), // Primary color
    brightness: Brightness.light,
  ),
  useMaterial3: true, // Enabling Material 3 UI components
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 57.sp, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 45.sp, fontWeight: FontWeight.bold, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 36.sp, fontWeight: FontWeight.bold, color: Colors.black),
    headlineLarge: TextStyle(
        fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black),
    titleMedium: TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
    titleSmall: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.normal, color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: TextStyle(
        fontSize: 12.sp, fontWeight: FontWeight.normal, color: Colors.black),
    labelLarge: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
    labelMedium: TextStyle(
        fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black),
    labelSmall: TextStyle(
        fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.black),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFB14BA8),
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // Text and icon color when enabled
      backgroundColor: const Color(0xFFB14BA8), // Background color
      disabledForegroundColor:
          Colors.white.withOpacity(0.38), // Disabled text color
      disabledBackgroundColor: const Color(0xFFB14BA8)
          .withOpacity(0.12), // Disabled background color
      shadowColor: Colors.black.withOpacity(0.3), // Shadow color
      elevation: 4, // Elevation of the button
      textStyle: const TextStyle(fontWeight: FontWeight.bold), // Text style
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 12.0), // Button padding
      minimumSize: Size(64.w, 36.h), // Minimum size for the button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      visualDensity: VisualDensity.standard, // Default visual density
      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Tap target size
      alignment: Alignment.center, // Alignment of content
      splashFactory: InkRipple.splashFactory, // Splash effect
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFB14BA8),
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFB14BA8)),
    ),
    labelStyle: const TextStyle(color: Colors.black),
    hintStyle: const TextStyle(color: Colors.black45),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.3),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFB14BA8), // Primary color
    brightness: Brightness.dark,
  ),
  useMaterial3: true, // Enabling Material 3 UI components
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 57.sp, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 45.sp, fontWeight: FontWeight.bold, color: Colors.white),
    displaySmall: TextStyle(
        fontSize: 36.sp, fontWeight: FontWeight.bold, color: Colors.white),
    headlineLarge: TextStyle(
        fontSize: 32.sp, fontWeight: FontWeight.w600, color: Colors.white),
    headlineMedium: TextStyle(
        fontSize: 28.sp, fontWeight: FontWeight.w600, color: Colors.white),
    headlineSmall: TextStyle(
        fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 22.sp, fontWeight: FontWeight.w500, color: Colors.white),
    titleMedium: TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
    bodyLarge: TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: TextStyle(
        fontSize: 12.sp, fontWeight: FontWeight.normal, color: Colors.white),
    labelLarge: TextStyle(
        fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
    labelMedium: TextStyle(
        fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white),
    labelSmall: TextStyle(
        fontSize: 11.sp, fontWeight: FontWeight.w500, color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFB14BA8),
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black, // Text and icon color when enabled
      backgroundColor: const Color(0xFFB14BA8), // Background color
      disabledForegroundColor:
          Colors.black.withOpacity(0.38), // Disabled text color
      disabledBackgroundColor: const Color(0xFFB14BA8)
          .withOpacity(0.12), // Disabled background color
      shadowColor: Colors.black.withOpacity(0.3), // Shadow color
      elevation: 4, // Elevation of the button
      textStyle: const TextStyle(fontWeight: FontWeight.bold), // Text style
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 12.0), // Button padding
      minimumSize: Size(64.w, 36.h), // Minimum size for the button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      visualDensity: VisualDensity.standard, // Default visual density
      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Tap target size
      alignment: Alignment.center, // Alignment of content
      splashFactory: InkRipple.splashFactory, // Splash effect
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFB14BA8),
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFB14BA8)),
    ),
    labelStyle: const TextStyle(color: Colors.white),
    hintStyle: const TextStyle(color: Colors.white70),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[900],
    shadowColor: Colors.black.withOpacity(0.3),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);
