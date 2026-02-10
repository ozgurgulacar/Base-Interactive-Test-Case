import 'package:base_interactive_test_case/presentations/status/web_socket_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_providers.dart';


class WebSocketStatusBanner extends StatelessWidget {
  const WebSocketStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<MarketProviders, WebSocketStatus>(
      (vm) => vm.webSocketStatus,
    );

    final errorMessage = context.select<MarketProviders, String?>(
      (vm) => vm.errorMessageWebSocket,
    );

    final vm = context.read<MarketProviders>();

    if (status == WebSocketStatus.error && errorMessage != null) {
      return _ErrorBanner(errorMessage: errorMessage);
    }

    if (status == WebSocketStatus.disconnected) {
      return _DisconnectedBanner(onRefresh: vm.connectWebSocket);
    }

    return const SizedBox.shrink();
  }
}


class _ErrorBanner extends StatelessWidget {
  final String errorMessage;

  const _ErrorBanner({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
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
  }
}


class _DisconnectedBanner extends StatelessWidget {
  final VoidCallback onRefresh;

  const _DisconnectedBanner({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
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
            onPressed: onRefresh,
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
}

