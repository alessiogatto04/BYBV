import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Modifica extends StatefulWidget {
  const Modifica({super.key});

  @override
  State<Modifica> createState() => _ModificaState();
}

class _ModificaState extends State<Modifica> {
  String? selectedSex;

  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        title: const Text(
          "Modifica Profilo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, //TORNA ALLA PAGINA DI PRIMA NON SALVANDO
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed:
                () {}, //TORNA ALLA PAGINA DI PRIMA SALVANDO TUTTI I DATI E CAMBIAMENTI
            child: const Text(
              "Fatto",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.12,
                    backgroundColor: Colors.black,
                    backgroundImage: const AssetImage("images/imgprofile.png"),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.015),

            const Text(
              "Dati pubblici",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            SizedBox(height: screenHeight * 0.02),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Nome",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Inserisci nome",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Bio",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Scrivi una bio",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Link",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "https://example.com",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),

            const Text(
              "Dati Privati",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            SizedBox(height: screenHeight * 0.02),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Sesso",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSex,
                      dropdownColor: Colors.black,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      hint: const Text(
                        "Seleziona",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "M",
                          child: Text(
                            "Maschio",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "F",
                          child: Text(
                            "Femmina",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "N",
                          child: Text(
                            "Non specificato",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSex = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Colors.grey),

            Row(
              children: [
                SizedBox(
                  width: screenWidth * 0.25,
                  child: const Text(
                    "Data di nascita",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                SizedBox(width: screenWidth * 0.14,
                child: TextField(
                  controller: dayController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: "Giorno",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    isDense: true,
                    counterText: "",
                  ),
                ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text("/",
                style: TextStyle(color: Colors.white),
                ),
                ),
                SizedBox(width: screenWidth * 0.14,
                child: TextField(
                  controller: monthController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: "Mese",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    isDense: true,
                    counterText: "",
                  ),
                ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text("/",
                style: TextStyle(color: Colors.white),
                ),
                ),
                SizedBox(width: screenWidth * 0.20,
                child: TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: const InputDecoration(
                    hintText: "Anno",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    isDense: true,
                    counterText: "",
                  ),
                ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text("/",
                style: TextStyle(color: Colors.white),
                ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
