import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingWidget extends StatefulWidget {
  final String recipeId;

  const RatingWidget({super.key, required this.recipeId});

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _userRating = 0;
  double _averageRating = 0;
  int _ratingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  Future<void> _loadRating() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Load user's rating
    final userRatingDoc = await FirebaseFirestore.instance
        .collection('ratings')
        .doc('${widget.recipeId}_${user.uid}')
        .get();

    if (userRatingDoc.exists) {
      setState(() => _userRating = userRatingDoc.data()?['rating'] ?? 0);
    }

    // Load average rating
    final ratingsQuery = await FirebaseFirestore.instance
        .collection('ratings')
        .where('recipeId', isEqualTo: widget.recipeId)
        .get();

    if (ratingsQuery.docs.isNotEmpty) {
      double total = 0;
      for (var doc in ratingsQuery.docs) {
        total += doc.data()['rating'];
      }
      setState(() {
        _averageRating = total / ratingsQuery.docs.length;
        _ratingCount = ratingsQuery.docs.length;
      });
    }
  }

  Future<void> _submitRating(double rating) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('ratings')
        .doc('${widget.recipeId}_${user.uid}')
        .set({
          'recipeId': widget.recipeId,
          'userId': user.uid,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

    setState(() => _userRating = rating);
    _loadRating(); // Reload average
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Bewertung',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _userRating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => _submitRating(index + 1.0),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Ø ${_averageRating.toStringAsFixed(1)} ($_ratingCount Bewertungen)',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
