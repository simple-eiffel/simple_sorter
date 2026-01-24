# 7S-06: SIZING
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Current Size

### Source Files
- **Classes**: 5 Eiffel classes
- **Lines**: ~900 lines of Eiffel code
- **Test Classes**: 2

### Class Breakdown
| Class | Lines | Responsibility |
|-------|-------|----------------|
| SIMPLE_SORTER | 617 | Facade with all user-facing features |
| SIMPLE_SORT_ALGORITHM | 163 | Deferred base class |
| SIMPLE_INTROSORT | 297 | Hybrid algorithm |
| SIMPLE_MERGE_SORT | ~150 | Stable sort |
| SIMPLE_HEAP_SORT | 127 | In-place O(1) space |
| SIMPLE_INSERTION_SORT | ~80 | Small data optimizer |

## Complexity Assessment

- **Features in SIMPLE_SORTER**: 20+ public features
- **MML Contract Features**: 5 (model queries)
- **Algorithm Implementations**: 4
- **Constants**: 2 (threshold, model check limit)

## Performance Characteristics

| Input Size | Introsort | Merge Sort | Heap Sort |
|------------|-----------|------------|-----------|
| 10 | Insertion | - | - |
| 100 | Quick | Merge | Heap |
| 1000 | Quick/Heap | Merge | Heap |
| 10000+ | Quick/Heap | Merge | Heap |

## Growth Projections

- Stable architecture
- Potential: Timsort implementation
- Potential: Parallel sort
- Potential: External sort for huge data
