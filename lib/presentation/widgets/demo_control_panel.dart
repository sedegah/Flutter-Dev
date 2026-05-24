import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';

class DemoControlPanel extends StatefulWidget {
  final ApiService apiService;

  const DemoControlPanel({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<DemoControlPanel> createState() => _DemoControlPanelState();
}

class _DemoControlPanelState extends State<DemoControlPanel> {
  late int networkLatency;
  late bool forceFailure;

  @override
  void initState() {
    super.initState();
    networkLatency = widget.apiService.networkLatencyMs;
    forceFailure = widget.apiService.forceFailure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(color: Colors.blue[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo Control Panel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // Network Latency Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Network Latency: ${networkLatency}ms',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Slider(
                min: 0,
                max: 3000,
                divisions: 30,
                value: networkLatency.toDouble(),
                onChanged: (value) {
                  setState(() {
                    networkLatency = value.toInt();
                    widget.apiService.setNetworkLatency(networkLatency);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Force Failure Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Force Out of Stock Failure',
                style: TextStyle(fontSize: 12),
              ),
              Switch(
                value: forceFailure,
                onChanged: (value) {
                  setState(() {
                    forceFailure = value;
                    widget.apiService.setForceFailure(forceFailure);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
