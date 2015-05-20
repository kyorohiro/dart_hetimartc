import 'dart:html' as html;
import 'dart:async' as async;
import 'package:hetimacore/hetimacore.dart';
import 'package:hetimartc/hetimartc.dart';

Caller callerA = new Caller("callerA");
Caller callerB = new Caller("callerB");

html.TextAreaElement callerAMessage = new html.Element.textarea();
html.TextAreaElement callerBMessage = new html.Element.textarea();

void main() {
  print("" + Uuid.createUUID());
  html.Element startButton = new html.Element.html('<input id="offerbutton" type="button" value="start"> ');
  html.Element sendAButton = new html.Element.html('<input id="send" type="button" value="send hello A->B"> ');
  html.Element sendBButton = new html.Element.html('<input id="send" type="button" value="send hello B->A"> ');

  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(startButton);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(sendAButton);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(sendBButton);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(new html.Element.html("<div>PeerA Message</div>"));
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(callerAMessage);
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(new html.Element.html("<div>PeerB Message</div>"));
  html.document.body.children.add(new html.Element.br());
  html.document.body.children.add(callerBMessage);
  html.document.body.children.add(new html.Element.br());

  
  startButton.onClick.listen(onClickStartButton);
  sendAButton.onClick.listen((html.MouseEvent event) {
    print("--clicked offer button");
    callerA.sendText("hello");
  });
  sendBButton.onClick.listen((html.MouseEvent event) {
    print("--clicked offer button");
    callerB.sendText("hello");
  });
}


void onClickStartButton(html.MouseEvent event) {
  print("--clicked offer button");
  callerA.signalclient = new AdapterSignalClient(callerB);
  callerA.targetUuid = "dummy callerB";
  callerB.signalclient = new AdapterSignalClient(callerA);
  callerB.targetUuid = "dummy callerA";

  callerA.connect();
  callerB.connect();
  (new async.Future.delayed(new Duration(seconds:3),(){
    callerA.createOffer();
  }));
  
  callerA.onReceiveMessage().listen((MessageInfo info) {
    print("#A# ${info.message}");
    callerAMessage.appendText("${info.message}");
  });
  callerB.onReceiveMessage().listen((MessageInfo info) {
    print("#B# ${info.message}");    
    callerBMessage.appendText("${info.message}");
  });
  callerA.onStatusChange().listen((String s) {
    print("callerA ${s}");
  });
  callerB.onStatusChange().listen((String s) {
    print("callerB ${s}");    
  });
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
    print("#####onreceive " + type + "," + data);
    super.onReceive(caller, to, from, type, data);
  }
}
