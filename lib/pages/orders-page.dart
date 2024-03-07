import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    // Initialize the orders stream
    _initializeOrdersStream();
  }

  void _initializeOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _ordersStream = FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }

  Future<void> _updateQuantity(String productId, String currentQuantity) async {
    var newQuantity = currentQuantity;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Quantity'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'New Quantity'),
            onChanged: (value) {
              newQuantity = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .update({'quantity': newQuantity});
                }
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }

          // If orders are available, display them in a list
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final productId = doc.id;
              final productName = doc['productName'];
              final quantity = doc['quantity'] as String; // Treat quantity as string
              final price = doc['price'] as String;
              return ListTile(
                title: Text(productName),
                subtitle: Text('Quantity: $quantity, Price: \$$price'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _updateQuantity(productId, quantity),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteOrder(productId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
