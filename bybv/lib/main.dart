import 'package:flutter/material.dart';

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
          backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}