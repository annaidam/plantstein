import 'dart:math';

/// Splits the given list [items] into a list of batches, each containing up to
/// [batchSize] items.
List<List<T>> splitIntoBatches<T>(List<T> items, int batchSize) {
  List<List<T>> batches = [];
  int numBatches = (items.length / batchSize).ceil();

  for (var i = 0; i < numBatches; i++) {
    int start = i * batchSize;
    int end = min(start + batchSize, items.length);
    batches.add(items.sublist(start, end));
  }

  return batches;
}
