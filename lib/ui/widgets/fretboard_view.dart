import 'package:flutter/material.dart';
import 'package:guitar_chord_helper/ui/model/guitar.dart';
import 'package:guitar_chord_helper/ui/utils/ui_utils.dart';

import 'guitar_fretborad_widget.dart';

class FretboardView extends StatefulWidget {
  const new({super.key});

  @override
  State<FretboardView> createState() => _FretboardViewState();
}

class _FretboardViewState extends State<FretboardView> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final guitar = Guitar();
    final guitarHeight = context.guitarHeigt;
    final stringsStep = guitarHeight / (Guitar.stringsCount + 1);
    // print('guitarHeigt: $guitarHeight, stringsStep: $stringsStep');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 10),
            child: Column(
              children: [
                Text('asd'),
                Container(
                  color: Colors.black.withAlpha(200),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        height: guitarHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: List.generate(Guitar.stringsCount, (index) {
                            final y = (index + 1) * stringsStep;
                            return Positioned(
                              top: y - 10,
                              left: 0,
                              right: 0,
                              height: 20,
                              child: Center(
                                child: Text(
                                  '${index + 1}弦',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final fretHeight = 20;
                            final totalHeigt = fretHeight + guitarHeight;
                            return SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width:
                                    guitar.fretCount.count * GuitarUI.fretStep,
                                height: totalHeigt,
                                child: Stack(
                                  children: [
                                    CustomPaint(
                                      size: Size(
                                        guitar.fretCount.count *
                                            GuitarUI.fretStep,
                                        guitarHeight,
                                      ),
                                      painter: GuitarFretboradPainter(
                                        guitar,
                                        stringsStep: stringsStep,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Text('data'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
