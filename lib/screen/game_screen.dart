import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int playerFortune = 0;
  int casinoFortune = Random().nextInt(91) + 10;
  String result = '';
  int diceResult = 1;
  final TextEditingController _amountController = TextEditingController();

  void _startGame() {
    setState(() {
      playerFortune = int.tryParse(_amountController.text) ?? 100;
      casinoFortune = Random().nextInt(91) + 10;
      result = '';
      diceResult = 1;
    });
  }

  void _addFunds(int amount) {
    setState(() {
      playerFortune += amount;
    });
  }

  void _rollDice() {
    int dice = Random().nextInt(6) + 1;
    setState(() {
      diceResult = dice;
      if (dice == 2 || dice == 3) {
        playerFortune += 1;
        casinoFortune -= 1;
      } else {
        playerFortune -= 1;
        casinoFortune += 1;
      }

      if (playerFortune <= 0) {
        result = 'Le casino gagne!';
      } else if (casinoFortune <= 0) {
        result = 'Le joueur gagne!';
      }
    });
  }

  Widget _buildStartGameSection() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Montant initial'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startGame,
          child: const Text('Commencer le jeu'),
        ),
      ],
    );
  }

  Widget _buildGameSection() {
    return Column(
      children: <Widget>[
        Text('Fortune du Joueur: $playerFortune'),
        Text('Fortune du Casino: $casinoFortune'),
        if (result.isNotEmpty) ...[
          Text(result, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                playerFortune = 0;
                _amountController.clear();
              });
            },
            child: const Text('Rejouer'),
          )
        ] else ...[
          ElevatedButton(
            onPressed: _rollDice,
            child: const Text('Lancer le dé'),
          ),
          const SizedBox(height: 20),
          if (result.isNotEmpty) Text(result, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),  // Display the result message
          Image.asset('assets/images/dice$diceResult.jpeg', height: 100, width: 100),
          ElevatedButton.icon(
            onPressed: () => _addFunds(10),
            icon: const Icon(FontAwesomeIcons.coins),
            label: const Text('Ajouter 10 au solde'),
          ),
          ElevatedButton.icon(
            onPressed: () => _addFunds(20),
            icon: const Icon(FontAwesomeIcons.coins),
            label: const Text('Ajouter 20 au solde'),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Casino Game')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),  // Increase padding
        child: Center(  // Center the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the column content vertically
            children: <Widget>[
              if (playerFortune == 0) _buildStartGameSection() else _buildGameSection(),
            ],
          ),
        ),
      ),
    );
  }
}