# 7S-05: SECURITY
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Security Considerations

### Threat Model

Sorting libraries have limited attack surface, but:

1. **Algorithmic Complexity Attacks**: Adversarial input causing worst-case
2. **Stack Overflow**: Deep recursion on large inputs
3. **Memory Exhaustion**: Merge sort's O(n) auxiliary space

### Mitigations

#### Introsort Defense
Introsort specifically defends against quicksort's O(n^2) worst case:
- Monitors recursion depth
- Switches to heapsort when depth exceeds 2*log2(n)
- Guarantees O(n log n) worst case

#### Stack Safety
```eiffel
log2_floor (a_n: INTEGER): INTEGER
    require
        n_positive: a_n > 0
```
- Depth limiting prevents stack overflow
- Tail recursion optimization where possible

#### Memory Bounds
- Introsort: O(log n) stack space only
- Heap sort: O(1) auxiliary space
- Merge sort: Explicit O(n) allocation

### Recommendations

1. Use introsort (default) for untrusted input sizes
2. Monitor memory for large merge sorts
3. Validate key extractors don't have side effects
4. Consider insertion sort threshold tuning
