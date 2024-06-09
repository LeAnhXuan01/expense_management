import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_management/widget/custom_header_2.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String? selectedWallet;
  String? selectedTimePeriod;

  List<String> wallets = ['Ví 1', 'Ví 2', 'Ví 3'];
  List<String> timePeriods = ['Ngày', 'Tuần', 'Tháng', 'Năm'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader_2(title: 'Thống Kê'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Chọn ví'),
                          value: selectedWallet,
                          items: wallets
                              .map((wallet) => DropdownMenuItem<String>(
                            value: wallet,
                            child: Text(wallet),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWallet = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Chọn thời gian'),
                          value: selectedTimePeriod,
                          items: timePeriods
                              .map((period) => DropdownMenuItem<String>(
                            value: period,
                            child: Text(period),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTimePeriod = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: 'Thu nhập và chi tiêu'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          dataSource: getChartData(),
                          xValueMapper: (ChartData data, _) => data.category,
                          yValueMapper: (ChartData data, _) => data.amount,
                          name: 'Số lượng',
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                  if (showProfitLossChart()) ...[
                    SizedBox(height: 20),
                    Expanded(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(
                            text: selectedWallet == 'Ví 1' ? 'Lợi nhuận' : 'Lỗ'),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            dataSource: getProfitLossChartData(),
                            xValueMapper: (ChartData data, _) => data.category,
                            yValueMapper: (ChartData data, _) => data.amount,
                            name: selectedWallet == 'Ví 1' ? 'Lợi nhuận' : 'Lỗ',
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> getChartData() {
    return [
      ChartData('Thu nhập', 5000),
      ChartData('Chi tiêu', 3000),
    ];
  }

  bool showProfitLossChart() {
    List<ChartData> data = getChartData();
    return data[0].amount != data[1].amount;
  }

  List<ChartData> getProfitLossChartData() {
    List<ChartData> data = getChartData();
    if (data[0].amount > data[1].amount) {
      return [ChartData('Lợi nhuận', data[0].amount - data[1].amount)];
    } else {
      return [ChartData('Lỗ', data[1].amount - data[0].amount)];
    }
  }
}

class ChartData {
  ChartData(this.category, this.amount);
  final String category;
  final double amount;
}
