// Copyright 2024 BenderBlog Rodriguez and Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:pinyin/pinyin.dart';

import 'dictionaries.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  TextEditingController inputController = TextEditingController(
    text: "抽像语言，也可称为 a3lang，是一个由 arttnba3 开发的语言。Oxcafebabe 在增添内容的基础上，释放了源代码。"
        "本页面基于释放代码基础上由 Benderblog Rodriguez 重写，权当 Flutter Web 的演示页面。",
  );

  TextEditingController resultController = TextEditingController();

  void onSubmitted() {
    String value = inputController.text;
    for (var i in abstractTableMulti.entries) {
      value = value.replaceAll(i.key, i.value);
    }

    List<String> toReturn = value.split('');
    for (int i = 0; i < toReturn.length; ++i) {
      String pinyin = PinyinHelper.getPinyinE(toReturn[i]);
      if (abstractTable.containsKey(pinyin)) {
        toReturn[i] = abstractTable[pinyin]
                ?[Random().nextInt(abstractTable[pinyin]?.length ?? 0 - 1)] ??
            toReturn[i];
      }
      bool change1 = Random().nextBool();
      bool change2 = Random().nextBool();
      if (toReturn[i].toLowerCase() == 'o' && change1 && change2) {
        toReturn[i] = '⭕️';
      }
      if (change1 &&
          tableChangeAlphabet.containsKey(toReturn[i].toLowerCase())) {
        toReturn[i] =
            tableChangeAlphabet[toReturn[i].toLowerCase()]?.toString() ??
                toReturn[i];
      }
    }
    resultController.text = toReturn.join();
  }

  bool get isHorizontal {
    Size size = MediaQuery.sizeOf(context);
    return size.height > size.width;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      TextFormField(
        key: const Key("input"),
        textAlignVertical: TextAlignVertical.top,
        expands: true,
        minLines: null,
        maxLines: null,
        controller: inputController,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      )
          .padding(horizontal: 12)
          .decorated(
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          )
          .expanded(),
      TextButton(
        key: const Key("button"),
        onPressed: onSubmitted,
        child: Text(isHorizontal ? "加密上面的文本" : "➡️"),
      ),
      TextField(
        key: const Key("output"),
        controller: resultController,
        readOnly: true,
        textAlignVertical: TextAlignVertical.top,
        expands: true,
        minLines: null,
        maxLines: null,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      )
          .padding(horizontal: 12)
          .decorated(
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          )
          .expanded(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("抽象话生成器")),
      body: Builder(builder: (context) {
        if (isHorizontal) {
          return widgetList.toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        } else {
          return widgetList.toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        }
      }).center().padding(horizontal: 16, vertical: 16).safeArea(),
    );
  }
}
