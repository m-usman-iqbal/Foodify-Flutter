import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeStatusServices {
  Future<void> changeStatus(
    String orderId,
    String customerId,
    String partnerId,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final doc1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(customerId)
        .collection('orders')
        .doc(orderId);

    final doc1snap = await doc1.get();
    final status = doc1snap.data()?['status'];
    // final bool doc1bool = checkStatus(status);

    batch.update(doc1, {
      'status': status == 'Completed' ? 'Pending' : 'Completed',
    });

    final doc2 = await FirebaseFirestore.instance
        .collection('partners')
        .doc(partnerId)
        .collection('orders')
        .doc(orderId);

    final doc2snap = await doc2.get();
    final status2 = doc2snap.data()?['status'];

    batch.update(doc2, {
      'status': status2 == 'Completed' ? 'Pending' : 'Completed',
    });
    await batch.commit();
  }
}
