import 'package:base_interactive_test_case/presentations/pages/market_page.dart';
import 'package:base_interactive_test_case/providers/market_providers.dart';
import 'package:base_interactive_test_case/repositories/market_repository.dart';
import 'package:base_interactive_test_case/services/binance_http_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final httpService = BinanceHttpService();
            final repository = MarketRepository(httpService);
            return MarketProviders(repository)..loadInitialData();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Base Interactive Test Case',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MarketPage()
    );
  }
}
