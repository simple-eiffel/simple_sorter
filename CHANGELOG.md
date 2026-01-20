# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-20

### Added

- SIMPLE_SORTER [G] facade class with agent-based comparison
- SIMPLE_SORT_ALGORITHM [G] deferred base class
- SIMPLE_INTROSORT [G] - hybrid quicksort/heapsort/insertion (default)
- SIMPLE_MERGE_SORT [G] - stable O(n log n) sorting
- SIMPLE_HEAP_SORT [G] - in-place O(n log n) sorting
- SIMPLE_INSERTION_SORT [G] - simple O(n^2) for small data
- sort_by, sort_by_descending, sort_by_stable commands
- sort_array_by, sort_array_by_descending for direct array sorting
- is_sorted, is_sorted_descending queries
- Algorithm selection with set_algorithm
- Full Design by Contract (37 contract clauses)
- Void safety (void_safety="all")
- SCOOP compatibility (concurrency="scoop")
- 20 core tests
- 10 adversarial tests (edge cases, stress tests)
- Research documentation (7S workflow)
- Design audit documentation
- Contract audit documentation
- Hardening documentation

### Technical Details

- Agent-based comparison eliminates need for comparator classes
- Introsort uses median-of-three pivot selection
- Introsort falls back to heapsort at depth limit (2 log n)
- Introsort uses insertion sort for partitions < 16 elements
- Merge sort uses O(n) auxiliary space
- All algorithms preserve element count (postcondition verified)

### Tested Edge Cases

- Empty lists (precondition)
- Single elements
- All identical elements
- Already sorted data
- Reverse sorted data (quicksort worst case)
- Integer min/max values
- Large datasets (up to 100,000 elements)
- Stability preservation for equal elements
