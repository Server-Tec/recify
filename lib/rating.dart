import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import Firebase nur wenn verwendet
import '../main.dart' show USE_FIREBASE;
import 'package:cloud_firestore/cloud_firestore.dart' if (USE_FIREBASE) 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' if (USE_FIREBASE) 'package:firebase_auth/firebase_auth.dart';

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
    if (USE_FIREBASE) {
      await _loadRatingFirebase();
    } else {
      await _loadRatingLocal();
    }
  }

  Future<void> _loadRatingFirebase() async {
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

  Future<void> _loadRatingLocal() async {
    final prefs = await SharedPreferences.getInstance();

    // Load user's rating
    _userRating = prefs.getDouble('rating_${widget.recipeId}') ?? 0;

    // Load average rating (vereinfacht - nur eine Bewertung pro Rezept)
    _averageRating = _userRating;
    _ratingCount = _userRating > 0 ? 1 : 0;

    setState(() {});
  }

  Future<void> _saveRating(double rating) async {
    if (USE_FIREBASE) {
      await _saveRatingFirebase(rating);
    } else {
      await _saveRatingLocal(rating);
    }
  }

  Future<void> _saveRatingFirebase(double rating) async {
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

    // Reload to update average
    await _loadRating();
  }

  Future<void> _saveRatingLocal(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rating_${widget.recipeId}', rating);

    setState(() {
      _userRating = rating;
      _averageRating = rating;
      _ratingCount = rating > 0 ? 1 : 0;
    });
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
              onPressed: () => _saveRating(index + 1.0),
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
