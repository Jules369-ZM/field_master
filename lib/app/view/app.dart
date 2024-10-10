import 'package:auth_repo/auth_repo.dart';
import 'package:field_master/app/theme/theme.dart';
import 'package:field_master/auth/bloc/auth_bloc.dart';
import 'package:field_master/l10n/l10n.dart';
import 'package:field_master/login/view/login_page.dart';
import 'package:field_master/main/main.dart';
import 'package:field_master/utils/cubit/firebase_cubit.dart';
import 'package:field_master/utils/size_config.dart';
import 'package:field_master/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:services_repo/services_repo.dart';

class App extends StatelessWidget {
  const App({
    required this.authRepo,
    required this.servicesRepo,
    super.key,
  });

  final AuthRepo authRepo;
  final ServicesRepo servicesRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: servicesRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeCubit(authRepo)),
          BlocProvider(
            create: (context) => FirebaseCubit(
              authRepo: authRepo,
              servicesRepo: servicesRepo,
            ),
          ),
          BlocProvider(
            create: (context) => MainCubit(
              authRepo,
              servicesRepo,
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authenticationRepository: authRepo,
              firebaseCubit: context.read<FirebaseCubit>(),
              servicesRepository: servicesRepo,
            ),
          ),
        ],
        child: const _FSMPageView(),
      ),
    );
  }
}

class _FSMPageView extends StatelessWidget {
  const _FSMPageView();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle different Auth states if needed
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: const AppTheme().themeData,
        darkTheme: const AppDarkTheme().themeData,
        themeMode: context.watch<ThemeCubit>().state.mode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: EasyLoading.init(),
        navigatorKey: navKey,
        home: StreamBuilder(
          stream: authInstance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              context.read<AuthBloc>().add(
                    const AuthenticationStatusChanged(AuthStatus.authenticated),
                  );
              context.read<AuthBloc>().add(
                    FireBase(fireBaseUser: snapshot.data),
                  );
              return const MainPage();
            } else {
              context.read<AuthBloc>().add(
                    const AuthenticationStatusChanged(
                      AuthStatus.unauthenticated,
                    ),
                  );
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
