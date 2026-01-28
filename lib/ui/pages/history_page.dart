import 'package:flutter/material.dart';
import 'package:client_app/models/enums.dart';
import 'package:client_app/models/rate_model.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/ui/themes/west_themes.dart';
// Imports de nuestros nuevos componentes
import 'package:client_app/ui/components/history/rate_chart.dart';
import 'package:client_app/ui/components/history/currency_selector.dart';
import 'package:client_app/ui/components/history/time_filter_row.dart';
import 'package:client_app/ui/components/history/history_list_item.dart';

class HistoryPage extends StatefulWidget {
  final ApiClient apiClient;
  const HistoryPage({super.key, required this.apiClient});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<RateListResponse> _historyFuture;
  String _currentTimeFilter = '7d';
  Currency _selectedCurrency = Currency.BRL;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      switch (_currentTimeFilter) {
        case '1m':
          _historyFuture = widget.apiClient.getMonthRates();
          break;
        case '3m':
          _historyFuture = widget.apiClient.getThreeMonthRates();
          break;
        case '6m':
          _historyFuture = widget.apiClient.getSixMonthRates();
          break;
        default:
          _historyFuture = widget.apiClient.getWeekRates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WestColors.whiteBone,
      body: FutureBuilder<RateListResponse>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // FILTRADO LÓGICO: Aquí separamos BRL de USD antes de pintar
          final allRates = snapshot.data?.rates ?? [];
          final filteredRates = allRates
              .where((r) => r.fromCurrency == _selectedCurrency)
              .toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CurrencySelector(
                        selected: _selectedCurrency,
                        onSelected: (c) =>
                            setState(() => _selectedCurrency = c),
                      ),
                      const SizedBox(height: 16),
                      TimeFilterRow(
                        currentFilter: _currentTimeFilter,
                        onFilterChanged: (f) {
                          _currentTimeFilter = f;
                          _fetchData();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: RateChart(rates: filteredRates.reversed.toList()),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => HistoryListItem(rate: filteredRates[i]),
                    childCount: filteredRates.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
