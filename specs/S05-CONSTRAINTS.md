# S05: CONSTRAINTS
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Technical Constraints

### Type System
- Generic [G] - sorts any type
- Key extractors return COMPARABLE
- Agents used for key extraction

### Algorithm Complexity
| Algorithm | Time (avg) | Time (worst) | Space | Stable |
|-----------|------------|--------------|-------|--------|
| Introsort | O(n log n) | O(n log n) | O(log n) | No |
| Merge Sort | O(n log n) | O(n log n) | O(n) | Yes |
| Heap Sort | O(n log n) | O(n log n) | O(1) | No |
| Insertion Sort | O(n^2) | O(n^2) | O(1) | Yes |

### Introsort Parameters
- `Insertion_threshold`: 16 (switch to insertion sort)
- `Max_depth`: 2 * log2(n) (switch to heap sort)

## Design Constraints

### List Handling
- Lists converted to arrays internally
- Copy back after sorting
- Extra O(n) space for list sorting

### MML Model Checking
- `Model_check_threshold`: 1000
- Larger collections skip expensive bag/sequence checks
- O(n) sorted check always runs

### Stability
- Introsort: NOT stable
- Must use merge_sort for guaranteed stability
- sort_by_stable auto-switches to merge sort

## Operational Constraints

### Performance
- Agent calls have overhead
- Key extractor called O(n log n) times
- Consider caching expensive keys

### Memory
- Merge sort: O(n) extra space
- Introsort: O(log n) stack space
- List sorting: O(n) for array copy

### Threading
- NOT thread-safe
- Create separate sorter per thread
- SCOOP-compatible design
