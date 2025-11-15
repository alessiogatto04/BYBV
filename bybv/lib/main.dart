import 'package:flutter/material.dart'; //Flutter dispone di tutte le funzionalità, 
// colori e widget, noti come material component, necessari per lo sviluppo di applicazioni che rispettino i principi del material design.

void main() {
  runApp(const BYBV());
}

class BYBV extends StatelessWidget {
  const BYBV({super.key});


  @override
  Widget build(BuildContext context) {
    //Metodo che costruisce l'interfaccia grafica dell'applicazione
    return MaterialApp(home: BYBVHomePage(),);
  }
}

class BYBVHomePage extends StatefulWidget {
  const BYBVHomePage({super.key});

  @override
  State<BYBVHomePage> createState() => _BYBVHomePageState();
}

class _BYBVHomePageState extends State<BYBVHomePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Become Your Best Version',
          ),
          backgroundColor: const Color.fromARGB(255, 30, 136, 229),
      ),
    );
  }
}