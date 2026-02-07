import 'package:base_interactive_test_case/presentations/status/market_status.dart';
import 'package:base_interactive_test_case/presentations/status/web_socket_status.dart';
import 'package:base_interactive_test_case/presentations/widgets/market_row.dart';
import 'package:base_interactive_test_case/providers/market_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  void initState() {
    super.initState();

    final marketProvider = context.read<MarketProviders>();
    Future.microtask(() => marketProvider.refreshData());
  }

  @override
  void dispose() {
    super.dispose();
    final marketProvider = context.read<MarketProviders>();
    marketProvider.disconnectWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MarketProviders>();
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E11),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Markets',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.2,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Selector<MarketProviders, Map<String, dynamic>>(
            selector: (_, provider) => {
              'errorMessage': provider.errorMessageWebSocket,
              'status': provider.webSocketStatus,
            },
            builder: (context, data, child) {
              final errorMessage = data['errorMessage'] as String?;
              final status = data['status'] as WebSocketStatus;

              if (status == WebSocketStatus.error && errorMessage != null) {
                return Container(
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (status == WebSocketStatus.disconnected) {
                return Container(
                  color: Colors.orangeAccent,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Data is currently not being updated',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          vm.connectWebSocket();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),

          _MarketHeader(),
          const Divider(height: 1, color: Color(0xFF1E2329)),
          Expanded(child: _buildBody(vm)),
        ],
      ),
    );
  }

  Widget _buildBody(MarketProviders vm) {
    switch (vm.status) {
      case MarketStatus.loading:
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
            strokeWidth: 2.5,
          ),
        );

      case MarketStatus.error:
        return _ErrorView(message: vm.errorMessage, onRetry: vm.refreshData);

      case MarketStatus.success:
        return Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: vm.symbols.length,
            itemBuilder: (context, index) {
              final symbol = vm.symbols[index];
              return MarketRow(key: ValueKey(symbol), symbol: symbol);
            },
          ),
        );

      default:
        return const SizedBox();
    }
  }
}

class _MarketHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFF0B0E11),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              'Market',
              style: TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Price',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Change',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF848E9C),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.redAccent, size: 56),
            const SizedBox(height: 16),
            Text(
              message ?? 'Unable to load market data',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF848E9C), fontSize: 14),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.amber),
                foregroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
