

// 定义观察者接口
import 'package:flutter/material.dart';

abstract class Observer {
  void update(String message);
}

// 定义具体观察者
class ConcreteObserver implements Observer {
  @override
  void update(String message) {
    print("Received message: $message");
  }
}

// 定义主题接口
abstract class Subject {
  void attach(Observer observer);
  void detach(Observer observer);
  void notifyObservers();
}

class ConcreteSubject implements Subject {

  List<Observer> _observers = [];

  late String _state;

  @override
  void attach(Observer observer) {
     _observers.add(observer);
  }

  @override
  void detach(Observer observer) {
    _observers.remove(observer);
  }

  @override
  void notifyObservers() {
    for (var observer in _observers) {
      observer.update(_state);
    }
  }

  void setState(String state) {
    _state = state;
    notifyObservers();
  }
}

class ObserveDemo {
  void main() {
    ConcreteSubject subject = ConcreteSubject();
    ConcreteObserver observer1 = ConcreteObserver();
    ConcreteObserver observer2 = ConcreteObserver();

    subject.attach(observer1);
    subject.attach(observer2);

    subject.setState("hello,Observers");
  }
}

/*
在这个示例中，ConcreteSubject是被观察者，
它维护了一个观察者列表，并提供了注册、注销和通知观察者的方法。ConcreteObserver是观察者，它实现了Observer接口，
并在收到通知时打印消息。当被观察者的状态发生变化时，它会遍历观察者列表，并调用每个观察者的update方法。
 */