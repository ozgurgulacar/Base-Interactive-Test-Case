import 'package:base_interactive_test_case/models/market_item.dart';
import 'package:base_interactive_test_case/presentations/pages/market_detail_page.dart';
import 'package:base_interactive_test_case/providers/market_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketRow extends StatelessWidget {
  final String symbol;

  const MarketRow({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MarketDetailPage(symbol: symbol)),
        );
      },
      child: Selector<MarketProviders, MarketItem?>(
        selector: (_, vm) => vm.getItem(symbol),
        shouldRebuild: (prev, next) {
          if (prev == null || next == null) return true;
          return prev.lastPrice != next.lastPrice ||
              prev.priceChangePercent != next.priceChangePercent;
        },
        builder: (context, item, _) {
          if (item == null) return const SizedBox();

          final changePercent = item.priceChangePercent;
          final isPositive = changePercent >= 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E2329))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item.symbol,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: RepaintBoundary(
                    child: Text(
                      item.lastPrice.toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPositive
                            ? const [Color(0xFF0ECB81), Color(0xFF16C784)]
                            : const [Color(0xFFF6465D), Color(0xFFEA3943)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: RepaintBoundary(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                            size: 18,
                          ),
                          Text(
                            '${changePercent.abs().toStringAsFixed(2)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
