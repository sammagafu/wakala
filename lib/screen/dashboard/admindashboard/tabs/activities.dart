import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wakala/constants/constants.dart';

class AdminActivities extends StatefulWidget {
  const AdminActivities({Key? key}) : super(key: key);

  @override
  _AdminActivitiesState createState() => _AdminActivitiesState();
}

class _AdminActivitiesState extends State<AdminActivities> {
  final Stream<QuerySnapshot> _transaction = FirebaseFirestore.instance
      .collection('transaction')
      .where('is_completed', isEqualTo: true)
      .where('agent', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy("request_time", descending: false)
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 65, 15, 30),
      color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Activities",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _transaction,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['service'],
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(data['carrier']),
                        ],
                      ),
                      subtitle: Text(
                        data['amount'],
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
