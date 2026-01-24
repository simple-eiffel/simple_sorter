# S07: SPECIFICATION SUMMARY
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## One-Line Description

Modern, ergonomic sorting library for Eiffel with agent-based key extraction, multiple algorithms, and full MML contracts.

## Key Specifications

| Aspect | Specification |
|--------|---------------|
| **Type** | Foundation Utility |
| **Generic** | SIMPLE_SORTER [G] |
| **Default Algorithm** | Introsort (O(n log n) guaranteed) |
| **Stable Algorithm** | Merge Sort |
| **Key Pattern** | FUNCTION [G, COMPARABLE] agents |
| **Contracts** | Full MML (sequence, bag, sorted) |

## Algorithms

| Algorithm | Time | Space | Stable | Use Case |
|-----------|------|-------|--------|----------|
| Introsort | O(n log n) | O(log n) | No | General purpose (default) |
| Merge Sort | O(n log n) | O(n) | Yes | Stability required |
| Heap Sort | O(n log n) | O(1) | No | Memory constrained |
| Insertion Sort | O(n^2) | O(1) | Yes | Small data (n < 16) |

## Typical Usage

```eiffel
-- Basic sort by key
create sorter.make
sorter.sort_by (people, agent {PERSON}.age)

-- Descending
sorter.sort_by_descending (people, agent {PERSON}.salary)

-- Multi-key sort
sorter.sort_by_keys (people,
    <<agent {PERSON}.department, agent {PERSON}.name>>,
    <<False, False>>)

-- Stable sort
sorter.sort_by_stable (people, agent {PERSON}.department)

-- Algorithm selection
sorter.set_algorithm (sorter.heap_sort)
sorter.sort_by (huge_list, agent {RECORD}.id)
```

## Critical Invariants

1. count unchanged after sort
2. result is permutation of input (MML_BAG equality)
3. result is sorted by key (MML_SEQUENCE ordering)
4. introsort guarantees O(n log n) worst case
5. merge sort guarantees stability
