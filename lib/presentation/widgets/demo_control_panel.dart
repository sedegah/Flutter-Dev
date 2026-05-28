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

    final borderColor = isDark ? const Color(0xFF2E3B4E) : const Color(0xFFE2E8F0);
    final bgColor = isDark ? const Color(0xFF0F172A).withOpacity(0.5) : const Color(0xFFF8FAFC);
    final textColor = theme.colorScheme.onSurface;
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title (Uppercase, flat, minimal)
          Text(
            'DEMO SETTINGS',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 1.0,
              color: textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 14),
          // Latency Controller
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LATENCY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${networkLatency}ms',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: textColor,
                        inactiveTrackColor: borderColor,
                        thumbColor: textColor,
                        overlayColor: textColor.withOpacity(0.1),
                      ),
                      child: Slider(
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
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Force Failure switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              color: isDark ? const Color(0xFF1E293B).withOpacity(0.3) : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FORCE OUT OF STOCK ERROR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: textColor,
                  ),
                ),
                SizedBox(
                  height: 24,
                  child: Switch(
                    value: forceFailure,
                    onChanged: (value) {
                      setState(() {
                        forceFailure = value;
                        widget.apiService.setForceFailure(forceFailure);
                      });
                    },
                    activeColor: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                    activeTrackColor: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    inactiveThumbColor: subtextColor,
                    inactiveTrackColor: borderColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
