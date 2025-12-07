import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamplay/providers/theme_provider.dart';
import 'package:streamplay/routes/routes.dart';
import 'package:streamplay/widgets/app_background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
      systemNavigationBarColor: Colors.red,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const StreamPlay());
}

class StreamPlay extends StatelessWidget {
  const StreamPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: AppBackground(
        child: Consumer(
          builder: (context, ref, child) {
            final themeMode = ref.watch(themeProvider);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'StreamPlay',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
                useMaterial3: true,
                scaffoldBackgroundColor: Colors.transparent,
              ),
              darkTheme: ThemeData.dark(
                useMaterial3: true,
              ).copyWith(scaffoldBackgroundColor: Colors.transparent),
              themeMode: themeMode,
              initialRoute: AppRoutes.splash,
              routes: AppRoutes.getRoutes(),
              onGenerateRoute: AppRoutes.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
