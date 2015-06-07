import 'dart:html' as html;
import 'dart:async' as async;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimartc/hetimartc.dart';


html.CanvasElement canvasElm = new html.Element.canvas();

void main() {
  print("" + Uuid.createUUID());
  
  html.Element startButton = new html.Element.html('<input id="offerbutton" type="button" value="start"> ');
  canvasElm.width = 100;
  canvasElm.height = 100;
  html.document.body.children.add(canvasElm);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(startButton);
  html.document.body.children.add(new html.Element.br());

  
  startButton.onClick.listen((html.MouseEvent event) {
    print("--clicked offer button");
  });
}
