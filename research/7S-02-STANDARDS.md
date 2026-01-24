# 7S-02: STANDARDS
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Applicable Standards

### Algorithm Standards
- **Introsort**: Hybrid quicksort/heapsort/insertion (Musser 1997)
- **Merge Sort**: Stable O(n log n) with O(n) space
- **Heap Sort**: In-place O(n log n)
- **Insertion Sort**: Stable O(n^2), optimal for small data

### Eiffel MML Standards
- **MML_SEQUENCE**: Ordered collection model
- **MML_BAG**: Unordered multiset model
- **Permutation**: bag(result) = bag(input)
- **Sorted**: ordered sequence property

### Complexity Guarantees
| Algorithm | Time (avg) | Time (worst) | Space | Stable |
|-----------|------------|--------------|-------|--------|
| Introsort | O(n log n) | O(n log n) | O(log n) | No |
| Merge Sort | O(n log n) | O(n log n) | O(n) | Yes |
| Heap Sort | O(n log n) | O(n log n) | O(1) | No |
| Insertion Sort | O(n^2) | O(n^2) | O(1) | Yes |

## Design Patterns

1. **Strategy Pattern**: Pluggable algorithms via SIMPLE_SORT_ALGORITHM
2. **Facade Pattern**: SIMPLE_SORTER provides easy-to-use API
3. **Key Extractor Pattern**: Agent functions for sort keys
4. **Specification via Contract**: MML-based postconditions
