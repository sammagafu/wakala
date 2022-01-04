import 'package:flutter/material.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final bool _availability = true;
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 65, 15, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Offline"),
              Switch(
                value: _availability,
                onChanged: (value) {},
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Distance"),
              Slider(
                min: 1,
                max: 4,
                activeColor: Colors.green,
                inactiveColor: Colors.orange,
                onChanged: (double newValue) {
                  setState(() {
                    _value = newValue.round();
                  });
                },
                value: _value.toDouble(),
              ),
              Text("${_value.toString()} Km")
            ],
          ),
          SizedBox(
            height: 45,
          ),
          OutlinedButton(
              onPressed: () {
                // Navigator.pushNamed(context, Login.id);
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  side: BorderSide(color: Colors.white)),
              child: Text(
                "Save Settings",
                style: Theme.of(context).textTheme.bodyText2,
              )),
        ],
      ),
    );
  }
}
