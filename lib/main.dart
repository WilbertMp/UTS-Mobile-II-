import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utsmobilewilbert/data/datasource/remote_datasource.dart';
import 'package:utsmobilewilbert/presentation/bloc/product_bloc.dart';
import 'package:utsmobilewilbert/presentation/pages/auth/login.dart';
import 'package:utsmobilewilbert/presentation/pages/auth/register.dart';
import 'package:utsmobilewilbert/presentation/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) =>
              ProductBloc(remoteDataSource: RemoteDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'My Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/home',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomeScreen(),
        },
        home: LoginPage(),
      ),
    );
  }
}
