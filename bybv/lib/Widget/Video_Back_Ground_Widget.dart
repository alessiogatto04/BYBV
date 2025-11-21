import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackGround extends StatefulWidget {
  final String videoPath;
  const VideoBackGround({super.key, required this.videoPath});

  @override
  State<VideoBackGround> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State <VideoBackGround>{
  late VideoPlayerController _controller; //late indica una variabile che verrà inizializzata più tardi

  @override
  void initState(){
    super.initState();
    _controller = VideoPlayerController.asset("video/homeScreenVideo.mp4") //con questo preleviamo il video come per le immagine 
      ..initialize().then((_){ // qua invece è relativo al fatto che verrà inizializzata a runtime la variabile
        _controller.setLooping(true); //Così mettiamo il video in loop
        _controller.play(); //così facciamo partire il video , prima però andava settato il loop
        setState(() {}); // il setState indica "Qualcosa è cambiato ridisegna il widget" , il parametro che gli passiamo è una funzione anonima in questo caso 
        // dove normalmente aggiorniamo lo stato dei nostri widget. Ma in questo caso non cambiamo variabili , ma abbiamo bisogno di ridisegnare la UI perchè_controller.value.isInitialized ora è true.
        // Senza questa setState , Flutter non sa che il video pronto e quindi il VideoPlayer non verrebbe mostrato. Quindi serve a notificare a Flutter solo che lo stato è cambiato
      });
  }

  @override
  // questo metodo è un metodo dei widget Stateful viene chiamato quando il widget viene rimosso dalla UI ( ad esempio , quando cambi pagina o chiudi lo schermo). serve in pratica 
  // a pulire le risorse allocate dal widget per evitare problemi in memoria (vedi memory leak). Quindi praticamente se non lo chiamiamo il video rimarrebbe "aperto" anche quando cambiamo pagina
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return _controller.value.isInitialized ? SizedBox.expand(
      child:FittedBox(
        fit: BoxFit.cover, //questo serve per ricoprire tutto lo schermo
        child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
        ),
      ),
    ):Container(color: Colors.black); // sfondo nero casomai il video non è pronto o non si carica subito
  }

}