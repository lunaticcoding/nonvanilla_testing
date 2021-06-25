extension IterableExtension<T> on Iterable<T> {
  Iterable<N> mapGrouped<N>(
    N Function(List<T>) map, {
    required int n,
  }) sync* {
    Iterable<T> ptr = this;
    while (ptr.isNotEmpty) {
      yield map(ptr.take(n).toList());
      ptr = ptr.skip(n);
    }
  }
}
