import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800], // Cinza escuro
        colorScheme: ColorScheme.dark(
          primary: Colors.grey[800]!,
          secondary: Colors.red,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _tempo = 1.0; // Valor inicial do slider
  String _esp32IpAddress = '192.168.1.1'; // Endereço IP padrão
  List<String> _acordes = [
    'Mi Menor',
    'Mi Maior',
    'La Menor',
    'Do Maior',
    'La Maior',
    'Sol Maior',
    'Ré Maior',
    'Ré Menor',
    'Mi Maior com Sétima',
    'Ré Maior com Sétima',
    'La com Sétima',
    'Do com Sétima',
  ];
  Map<String, int> _ordemAcordes = {};

  final _ipController =
  TextEditingController(text: '192.168.1.1'); // Controlador para o TextFormField

  // Adicione um estado para controlar a disponibilidade do botão
  bool _enviandoSequencia = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Assistente De Acordes BTF'),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            onSelected: (String value) {
              _mostrarDialogoIP(context);
            },
            itemBuilder: (BuildContext context) {
              return ['Configurar IP'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _acordes
                  .map(
                    (acorde) => ElevatedButton(
                  onPressed: _enviandoSequencia
                      ? null
                      : () {
                    _selecionarAcorde(acorde);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ordemAcordes.containsKey(acorde)
                        ? Colors.green // Cor verde se já foi selecionado
                        : Colors.red, // Cor vermelha se não foi selecionado
                  ),
                  child: Column(
                    children: [
                      Text(
                        _ordemAcordes.containsKey(acorde)
                            ? _ordemAcordes[acorde]
                            .toString() // Número do acorde
                            : '', // Mostra apenas se selecionado
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        acorde, // Nome do acorde
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tempo entre acordes: $_tempo',
              style: TextStyle(color: Colors.white), // Alterado para cor branca
            ),
            Slider(
              value: _tempo,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  _tempo = value;
                });
              },
              // Adicionando a cor vermelha ao slider
              activeColor: Colors.red,
            ),
            ElevatedButton(
              onPressed: _enviandoSequencia
                  ? null
                  : () {
                _enviarSequenciaDeAcordes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor vermelha para o botão
              ),
              child: Text(
                'Enviar Sequência de Acordes',
                style: TextStyle(color: Colors.grey[800]), // Texto preto escuro
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selecionarAcorde(String acorde) {
    setState(() {
      if (_ordemAcordes.containsKey(acorde)) {
        _ordemAcordes.remove(acorde);
      } else {
        _ordemAcordes[acorde] = _ordemAcordes.length + 1;
      }
    });
  }

  Future<void> _enviarSequenciaDeAcordes() async {
    if (_esp32IpAddress.isEmpty || _enviandoSequencia) {
      print('Endereço IP não fornecido ou já enviando sequência');
      return;
    }

    // Defina o estado do botão como indisponível
    setState(() {
      _enviandoSequencia = true;
    });

    List<String> sequenciaOrdenada = _ordemAcordes.keys.toList()
      ..sort((a, b) => _ordemAcordes[a]!.compareTo(_ordemAcordes[b]!));

    for (int i = 0; i < sequenciaOrdenada.length; i++) {
      try {
        var response = await http.post(
          Uri.parse('http://$_esp32IpAddress/enviar-mensagem'),
          body: {
            'tipo': 'Acorde',
            'acorde': sequenciaOrdenada[i],
            'ordem': (i + 1).toString(),
          },
        );

        if (response.statusCode == 200) {
          print('Acorde ${sequenciaOrdenada[i]} enviado com sucesso');
        } else {
          print(
              'Erro ao enviar acorde ${sequenciaOrdenada[i]}: ${response.statusCode}');
        }
      } catch (e) {
        print('Erro ao enviar o acorde ${sequenciaOrdenada[i]}: $e');
      }

      // Aguarda um intervalo definido pelo slider entre o envio de cada acorde
      await Future.delayed(Duration(seconds: _tempo.toInt()));
    }

    // Após enviar a sequência, reative o botão
    setState(() {
      _enviandoSequencia = false;
    });

    print('Sequência de acordes enviada com sucesso');
  }

  void _mostrarDialogoIP(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar Endereço IP'),
          content: Column(
            children: [
              Text('Insira o novo endereço IP:'),
              TextFormField(
                controller: _ipController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _esp32IpAddress = _ipController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
