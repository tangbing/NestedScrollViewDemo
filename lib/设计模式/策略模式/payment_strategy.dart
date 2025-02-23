

abstract class PaymentStrategy {
  void pay(double amount); // 抽象策略接口
}

class AlipayStrategy implements PaymentStrategy {
  @override
  void pay(double amount) {
      print('支付宝支付：¥${amount.toStringAsFixed(2)}');
  }
}

class WechatPayStrategy implements PaymentStrategy {
  @override
  void pay(double amount) {
    print('微信支付：¥${amount.toStringAsFixed(2)}');
  }
}

// 策略上下文(核心调度器)
class PaymentContext {
  PaymentStrategy _strategy;

  PaymentContext(this._strategy);

  void setStrategy(PaymentStrategy strategy) => _strategy = strategy;

  void executePay(double amount) => _strategy.pay(amount);
}

