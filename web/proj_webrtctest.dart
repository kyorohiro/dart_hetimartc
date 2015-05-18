import 'dart:html' as html;
import 'dart:async' as async;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimartc/hetimartc.dart';

Caller callerA = new Caller("callerA");
Caller callerB = new Caller("callerB");

void main() {
  print("" + Uuid.createUUID());
  html.Element startButton = new html.Element.html('<input id="offerbutton" type="button" value="start"> ');
  html.Element sendButton = new html.Element.html('<input id="send" type="button" value="send hello"> ');

  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(startButton);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(sendButton);
  html.document.body.children.add(new html.Element.br());

  startButton.onClick.listen(onClickStartButton);
  sendButton.onClick.listen(onClickSendButton);
}


void onClickSendButton(html.MouseEvent event) {
  print("--clicked offer button");
  callerA.sendText("hello");
}

void onClickStartButton(html.MouseEvent event) {
  print("--clicked offer button");
  callerA.signalclient = new AdapterSignalClient(callerB);
  callerA.setTarget("dummy callerB");
  callerB.signalclient = new AdapterSignalClient(callerA);
  callerB.setTarget("dummy callerA");

  callerA.connect();
  callerB.connect();
  (new async.Future.delayed(new Duration(seconds:3),(){
    callerA.createOffer();
  }));
}


class AdapterSignalClient extends CallerExpectSignalClient {
  Caller _target = null;
  AdapterSignalClient(Caller target) {
    this._target = target;
  }
  void send(Caller caller, String toUUid, String from, String type, String data) {
    //if (type != CallerExpectSignalClient.typeIceCandidate) {
      print("signal client send ${data.substring(0,10)}");
      _target.signalclient.onReceive(_target, "dummy", "dummy", type, data);
    //}
  }
  void onReceive(Caller caller, String to, String from, String type, String data) {
    print("onreceive " + type + "," + data);
    super.onReceive(caller, to, from, type, data);
  }
}
