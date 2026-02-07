import 'package:base_interactive_test_case/presentations/status/web_socket_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/market_providers.dart';


class WebSocketStatusBanner extends StatelessWidget {
  const WebSocketStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<MarketProviders, Map<String, dynamic>>(
      selector: (_, provider) => {
        'errorMessage': provider.errorMessageWebSocket,
        'status': provider.webSocketStatus,
      },
      builder: (context, data, child) {
        final errorMessage = data['errorMessage'] as String?;
        final status = data['status'] as WebSocketStatus;
        final vm = context.read<MarketProviders>();

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
    );
  }
}
