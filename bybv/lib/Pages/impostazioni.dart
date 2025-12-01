import 'package:bybv/Pages/modifica.dart';
import 'package:flutter/material.dart';



class Settings_Page extends StatelessWidget {
  const Settings_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Impostazioni",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

        ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Profilo", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Modifica()),
              );
            },
        ),

          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text("Lingua", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              // onTap: onTap, //LISTA/PAGINA PER METTERE TUTTE LE LINGUE
            ),
          ),
          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.white),
              title: Text("Tema", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              // onTap: onTap, //SE USIAMO CON IL PULSANTE SWITCH CI SCRIVIAMO "MODALITÀ CHIARA" CHE SE ATTIATA METTE IL TEMA DELL'APP BIANCA, PERCHÈ È GIÀ SCURA DI DEFAULT
            ),
          ),
          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text(
                "Guida Introduttiva",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              //  onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => GuidaIntroduttiva()),
              //   );
              // }, //ALTRA PAGINA CHIAMATA "GUIDA INTRODUTTIVA" DOVE CI SCRIVIAMO LO SCOPO DELL'APP, COME REGISTRARE ALLENAMENTI MA NON TROPPO CHE SE POI FACCIAMO FOTO E ALTRO PERDIAMO TANTO TANTO TEMPO
            ),
          ),
          Container(
            color: Colors.black,
            child: ListTile(
              leading: Icon(Icons.question_mark_rounded, color: Colors.white),
              title: Text("Chi siamo?", style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.chevron_right, color: Colors.grey),
              //onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ChiSiamo()),
              //   );
              // }, //STESSA COSA DI SOPRA, AL MASSIMO NELLA PAGINA "CHI SIAMO" CI METTIAMO GIUSTO LA DESCRIZIONE DEI SOGGETTI 
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
//prova prova
