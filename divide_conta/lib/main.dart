import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text("Dividir Conta")),
          body: body(),
        ),
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)));
  }

  body() {
    return const Padding(padding: EdgeInsets.all(15), child: Form());
  }
}

class Form extends StatefulWidget {
  const Form({super.key});

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  final totalValueController = TextEditingController();
  final peopleController = TextEditingController();
  final waiterPercentController = TextEditingController();
  double totalValue = 0;
  double perPerson = 0;
  double waiterValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Valor total',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: totalValueController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Valor total é obrigatório';
                  }
                  double parsedValue = double.parse(value);

                  if (parsedValue <= 0) {
                    return 'Valor total deve ser maior que 0';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Pessoas', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: peopleController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pessoas é obrigatório';
                    }
                    int parsedValue = int.parse(value);

                    if (parsedValue <= 0) {
                      return 'Pessoas deve ser maior que 0';
                    }
                    return null;
                  }),
            )
          ],
        ),
        const SizedBox(height: 10),
        TextField(
            decoration: const InputDecoration(
                labelText: 'Porcentagem do garçom',
                border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: waiterPercentController),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: calculate, child: const Text("Dividir conta")),
        const SizedBox(height: 10),
        if (totalValue != 0) ...[
          Text("Valor total: R\$ $totalValue"),
          const SizedBox(height: 10),
          Text("Valor por pessoa: R\$ $perPerson"),
          const SizedBox(height: 10),
          Text("Valor do garçom: R\$ $waiterValue"),
        ]
      ],
    );
  }

  void calculate() {
    if (totalValueController.text.isEmpty || peopleController.text.isEmpty) {
      return;
    }
    if (double.parse(peopleController.text) == 0) {
      return;
    }
    double waiterPercent = waiterPercentController.text.isEmpty
        ? 0
        : double.parse(waiterPercentController.text);

    setState(() {
      waiterValue =
          double.parse(totalValueController.text) * (waiterPercent / 100);
      totalValue = double.parse(totalValueController.text) + waiterValue;
      perPerson = totalValue / double.parse(peopleController.text);
    });
  }
}
