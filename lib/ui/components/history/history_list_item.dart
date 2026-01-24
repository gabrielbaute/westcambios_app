import 'package:flutter/material.dart';
import 'package:client_app/models/rate_model.dart';

class HistoryListItem extends StatelessWidget {
  final RateResponse rate;

  const HistoryListItem({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${rate.rate.toStringAsFixed(2)} Bs",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                rate.timestamp.toString().substring(0, 10),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Icon(Icons.trending_up, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}
