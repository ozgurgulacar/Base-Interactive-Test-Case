import 'package:base_interactive_test_case/presentations/widgets/web_socket_status_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_providers.dart';
import '../../models/market_item.dart';

class MarketDetailPage extends StatelessWidget {
  final String symbol;

  const MarketDetailPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        centerTitle: true,
        title: Text(
          symbol,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Column(
        children: [

          WebSocketStatusBanner(),

          Selector<MarketProviders, MarketItem?>(
            selector: (_, vm) => vm.getItem(symbol),
            builder: (_, item, _) {
              if (item == null) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                );
              }

              final isPositive = item.priceChangePercent >= 0;
              final upColor = const Color(0xFF0ECB81);
              final downColor = const Color(0xFFF6465D);
              final mainColor = isPositive ? upColor : downColor;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2329),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Price',
                            style: const TextStyle(
                              color: Color(0xFF848E9C),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.lastPrice.toStringAsFixed(6),
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: mainColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _pill(
                                text: '${item.priceChange.toStringAsFixed(6)}',
                                color: mainColor,
                              ),
                              const SizedBox(width: 8),
                              _pill(
                                text:
                                    '${item.priceChangePercent.toStringAsFixed(2)}%',
                                color: mainColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _miniStat(
                            title: '24h High',
                            value: item.highPrice,
                            color: upColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _miniStat(
                            title: '24h Low',
                            value: item.lowPrice,
                            color: downColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _miniStat(title: 'Volume', value: item.volume),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Market Details'),
                    const SizedBox(height: 8),

                    _infoCard(
                      children: [
                        _infoRow('Open Price', item.openPrice),
                        _divider(),
                        _infoRow(
                          'Highest Buy',
                          item.bidPrice,
                          valueColor: upColor,
                        ),
                        _divider(),
                        _infoRow(
                          'Lowest Sell',
                          item.askPrice,
                          valueColor: downColor,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pill({required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _miniStat({
    required String title,
    required double value,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF848E9C), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value.toStringAsFixed(4),
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _infoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2329),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(
    String title,
    double value, {
    Color valueColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xFF848E9C), fontSize: 13),
          ),
          Text(
            value.toStringAsFixed(4),
            style: TextStyle(color: valueColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: Color(0xFF2B3139));
  }
}
