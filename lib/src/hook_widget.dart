import 'package:flutter/material.dart';
import './hook_element.dart';

abstract class HookWidget extends Widget {
  const HookWidget({Key key}) : super(key: key);

  @override
  RactorHookElement createElement() {
    return RactorHookElement(this);
  }

  Widget build();
}
