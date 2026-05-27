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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B).withOpacity(0.4), const Color(0xFF0F172A).withOpacity(0.4)]
              : [const Color(0xFFF0F4FF), const Color(0xFFF8FAFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF243046) : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '🎮 Demo Control Panel',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Network Latency Slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⏱️ Network Latency',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${networkLatency}ms',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                activeColor: const Color(0xFF6366F1),
                inactiveColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '0ms',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '3000ms',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Force Failure Toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔴 Force Out of Stock',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                  ),
                ),
                Switch(
                  value: forceFailure,
                  onChanged: (value) {
                    setState(() {
                      forceFailure = value;
                      widget.apiService.setForceFailure(forceFailure);
                    });
                  },
                  activeColor: const Color(0xFFDC2626),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
