# 7S-03: SOLUTIONS
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Existing Solutions Analyzed

### 1. EiffelBase SORTER
- **Pros**: Standard library, familiar
- **Cons**: Limited algorithms, no key extractor, basic contracts

### 2. COMPARABLE.compare
- **Pros**: Standard pattern
- **Cons**: Requires implementing COMPARABLE, single sort order

### 3. ds_sorter (Gobo)
- **Pros**: Well-tested
- **Cons**: Requires Gobo ecosystem

### 4. Standard Library Sorts (other languages)
- C++ std::sort: Introsort-based
- Python: Timsort (hybrid)
- Java: Dual-pivot quicksort

## Why Build Custom?

1. **Key Extractor Pattern**: Sort by computed property without COMPARABLE
2. **MML Contracts**: Mathematical correctness proofs
3. **Algorithm Choice**: User selects best algorithm for data
4. **Multi-Key Sorting**: Primary + secondary + ... keys
5. **Modern API**: Fluent, ergonomic design

## Key Differentiators

- Full MML contracts (permutation + ordered)
- Agent-based key extractors
- Configurable algorithm selection
- Stable sort guarantee with merge sort
- Multi-key sort_by_keys feature
