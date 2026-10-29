import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tag_tweaker/models/pricing_rules.dart';
import 'package:tag_tweaker/models/quotation.dart';

/// Persists client quotations and the merchant's pricing rules under
/// `users/{uid}`. Only the owner can read or write these (see firestore.rules).
class QuotationRepository extends GetxService {
  QuotationRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Upper bound on quotations streamed into the history screen.
  static const int historyLimit = 50;

  CollectionReference<Map<String, dynamic>> _quotes(String uid) =>
      _firestore.collection('users').doc(uid).collection('quotations');

  DocumentReference<Map<String, dynamic>> _rulesDoc(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('settings')
      .doc('pricing');

  /// Saves [quote] and returns its new document id.
  Future<String> save(String uid, Quotation quote) async {
    final ref = await _quotes(uid).add(quote.toMap());
    return ref.id;
  }

  /// Newest-first stream of the user's saved quotations.
  Stream<List<Quotation>> watch(String uid) {
    return _quotes(uid)
        .orderBy('createdAt', descending: true)
        .limit(historyLimit)
        .snapshots()
        .map((s) => s.docs.map(Quotation.fromSnapshot).toList());
  }

  Future<void> delete(String uid, String quoteId) =>
      _quotes(uid).doc(quoteId).delete();

  Future<PricingRules> loadRules(String uid) async {
    final doc = await _rulesDoc(uid).get();
    return PricingRules.fromMap(doc.data());
  }

  Future<void> saveRules(String uid, PricingRules rules) =>
      _rulesDoc(uid).set(rules.toMap());
}
