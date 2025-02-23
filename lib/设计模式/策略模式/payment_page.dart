

import 'package:first_project/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F/%E7%AD%96%E7%95%A5%E6%A8%A1%E5%BC%8F/payment_strategy.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  PaymentContext _paymentContext = PaymentContext(AlipayStrategy());
  double _amount = 199.128;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('策略模式 Demo'),
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(onPressed: () => setState(() {
                _paymentContext.setStrategy(AlipayStrategy());
              }), child: Text('支付宝')),
              ElevatedButton(onPressed: () => setState(() {
                _paymentContext.setStrategy(WechatPayStrategy());
              }), child: Text('微信')),
              ElevatedButton(onPressed: () => setState(() {
                _paymentContext.executePay(_amount);
              }), child: Text('调起支付'))
            ],
          )
        ],
      ),
    );
  }
}
