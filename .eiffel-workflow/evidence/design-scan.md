# Design Scan: simple_sorter
# Date: 2026-02-12 (post-abstract + post-generify rescan)
# Classes scanned: 6
# Source files: 6

## Class Hierarchy (current)

```
SIMPLE_SORT_ALGORITHM [G -> detachable separate ANY] (deferred)
├── SIMPLE_HEAP_SORT [G -> detachable separate ANY]
├── SIMPLE_MERGE_SORT [G -> detachable separate ANY]
├── SIMPLE_INTROSORT [G -> detachable separate ANY]
└── SIMPLE_INSERTION_SORT [G -> detachable separate ANY]

SIMPLE_SORTER [G -> detachable separate ANY] (facade, delegates to SIMPLE_SORT_ALGORITHM [G])
```

## Previous Work (this session)

- Findings 1-4 from original scan: RESOLVED via /eiffel.abstract
  - swap moved to ancestor, heapify unified, postconditions added, is_sorted Template Method
- Finding 5 from original scan: RESOLVED via /eiffel.generify
  - All 6 classes now [G -> detachable separate ANY]

## Summary

| Category | Findings | High | Medium | Low |
|----------|----------|------|--------|-----|
| Abstraction | 5 | 0 | 2 | 3 |
| MI | 0 | 0 | 0 | 0 |
| Generics | 0 | 0 | 0 | 0 |
| **Total** | **5** | **0** | **2** | **3** |

## Findings

| # | Priority | Category | Classes | Opportunity | Effort | Suggested Skill |
|---|----------|----------|---------|-------------|--------|-----------------|
| 1 | MEDIUM | abstract | INTROSORT, INSERTION_SORT | Extract insertion_sort_range to ancestor | 1 feature | /eiffel.abstract |
| 2 | MEDIUM | abstract | SORTER | is_array_sorted delegates to algorithm.is_sorted | 1 feature | /eiffel.abstract |
| 3 | LOW | abstract | INTROSORT | Dead branching in median_of_three | 1 feature | /eiffel.abstract |
| 4 | LOW | abstract | SORTER | Missing postconditions on 5 features | 5 features | /eiffel.abstract |
| 5 | LOW | abstract | SORTER | comparator_sort uses O(n^2) insertion sort | 1 feature | /eiffel.abstract |

## Detailed Findings

### Finding 1: Extract insertion_sort_range to SIMPLE_SORT_ALGORITHM
**Priority:** MEDIUM
**Category:** A1 (Duplicate Feature)
**Classes:** SIMPLE_INTROSORT (src/simple_introsort.e), SIMPLE_INSERTION_SORT (src/simple_insertion_sort.e)
**Description:** INTROSORT.insertion_sort_range (lines 151-189) and INSERTION_SORT.sort (lines 29-70) implement the identical insertion sort algorithm with different bounds. The range version (a_left, a_right) is strictly more general than the full-array version (a_array.lower, a_array.upper). Extracting insertion_sort_range to the ancestor eliminates ~38 lines of duplicate logic and lets INSERTION_SORT.sort delegate with `insertion_sort_range(a_array, a_array.lower, a_array.upper, a_key, a_descending)`.
**Evidence:**
- SIMPLE_INTROSORT:line 151: `insertion_sort_range (a_array: ARRAY [G]; a_left, a_right: INTEGER; a_key: ...; a_descending: BOOLEAN)`
- SIMPLE_INSERTION_SORT:line 29: `sort (a_array: ARRAY [G]; a_key: ...; a_descending: BOOLEAN)` — body identical logic, bounds = a_array.lower/a_array.upper
**Suggested Action:** /eiffel.abstract — move insertion_sort_range to SIMPLE_SORT_ALGORITHM as effective helper, simplify INSERTION_SORT.sort to delegate
**Effort:** 1 feature to move, 1 feature body to simplify

### Finding 2: Delegate is_array_sorted to algorithm.is_sorted
**Priority:** MEDIUM
**Category:** A1 (Duplicate Logic via Delegation)
**Classes:** SIMPLE_SORTER (src/simple_sorter.e)
**Description:** SIMPLE_SORTER.is_array_sorted (lines 143-168) implements a 26-line ascending sorted check on ARRAY [G] that duplicates logic already available in SIMPLE_SORT_ALGORITHM.is_sorted (lines 111-142). Since SORTER holds `algorithm: SIMPLE_SORT_ALGORITHM [G]`, the body can be replaced with `Result := algorithm.is_sorted (a_array, a_key, False)`. This follows the delegation pattern already applied to is_sorted/is_sorted_descending (which delegate to is_weakly_sorted_by_key).
**Evidence:**
- SIMPLE_SORTER:line 143: `is_array_sorted` — 26-line loop body
- SIMPLE_SORT_ALGORITHM:line 111: `is_sorted` — same logic with descending parameter
**Suggested Action:** /eiffel.abstract — replace body with `Result := algorithm.is_sorted (a_array, a_key, False)`
**Effort:** 1-line body replacement

### Finding 3: Dead branching in median_of_three
**Priority:** LOW
**Category:** A1 (Code Quality)
**Classes:** SIMPLE_INTROSORT (src/simple_introsort.e)
**Description:** median_of_three (lines 117-149) branches on `a_descending` but both branches (lines 128-137 vs 138-148) are character-for-character identical. Median selection is direction-independent — the median of three values is the same regardless of sort direction. The entire `if a_descending then ... else ... end` can be collapsed to a single code path, saving ~10 lines.
**Evidence:**
- SIMPLE_INTROSORT:line 128-137: descending=True branch
- SIMPLE_INTROSORT:line 138-148: descending=False branch
- Both branches contain identical conditions and identical Result assignments
**Suggested Action:** /eiffel.abstract — collapse to single code path, remove dead branching
**Effort:** 1 feature cleanup, ~10 lines removed

### Finding 4: Missing postconditions on SORTER features
**Priority:** LOW
**Category:** A4 (Missing Contracts)
**Classes:** SIMPLE_SORTER (src/simple_sorter.e)
**Description:** Five features have incomplete contracts:
- `introsort` (line 419-424): empty `ensure` — should have `result_is_introsort: Result = internal_introsort`
- `merge_sort` (line 426-431): empty `ensure` — should have `result_is_merge_sort: Result = internal_merge_sort`
- `heap_sort` (line 433-438): empty `ensure` — should have `result_is_heap_sort: Result = internal_heap_sort`
- `insertion_sort` (line 440-445): empty `ensure` — should have `result_is_insertion_sort: Result = internal_insertion_sort`
- `sort_array_by_descending` (line 300-307): has `count_unchanged` but no `sorted` postcondition (contrast `sort_array_by` at line 290 which HAS `sorted: is_array_sorted (a_array, a_key)`)
**Evidence:**
- SIMPLE_SORTER:line 423-424: `ensure end` (empty)
- SIMPLE_SORTER:line 430-431: `ensure end` (empty)
- SIMPLE_SORTER:line 437-438: `ensure end` (empty)
- SIMPLE_SORTER:line 444-445: `ensure end` (empty)
- SIMPLE_SORTER:line 305-307: `ensure count_unchanged: ... end` — missing sorted check
- SIMPLE_SORTER:line 295-298: `ensure sorted: is_array_sorted (...) count_unchanged: ... end` — has sorted check
**Suggested Action:** /eiffel.abstract — add postconditions to all 5 features
**Effort:** 5 postconditions to add

### Finding 5: comparator_sort uses O(n^2) insertion sort
**Priority:** LOW
**Category:** A1 (Design Issue)
**Classes:** SIMPLE_SORTER (src/simple_sorter.e)
**Description:** comparator_sort (lines 504-536) implements insertion sort giving O(n^2) performance. It serves sort_by_comparator (line 357), sort_by_keys (line 384), and sort_array_by_keys (line 400). The main algorithm hierarchy provides O(n log n) but only accepts key extractors (`FUNCTION [G, COMPARABLE]`), not general comparators. This creates a performance gap for comparator-based sorts. A merge-sort-based comparator sort would maintain O(n log n) and stability.
**Evidence:**
- SIMPLE_SORTER:line 504: `comparator_sort` — insertion sort body (lines 512-533)
- SIMPLE_SORTER:line 357: called by `sort_by_comparator`
- SIMPLE_SORTER:line 384: called by `sort_by_keys`
- SIMPLE_SORTER:line 400: called by `sort_array_by_keys`
**Suggested Action:** /eiffel.abstract — rewrite comparator_sort using merge sort for O(n log n) + stability
**Effort:** 1 feature rewrite (~40 lines)

## MI Analysis

No MI opportunities found. Architecture is clean:
- SIMPLE_SORT_ALGORITHM is the single deferred ancestor (2-level hierarchy)
- No cross-cutting concerns duplicated across unrelated families
- SIMPLE_SORTER uses delegation (has-a) not inheritance — correct for a facade
- No missing standard parents (COMPARABLE/HASHABLE not applicable to sort algorithms)

## Generics Analysis

No generics opportunities remaining. All 6 classes now have `[G -> detachable separate ANY]` matching MML library constraints and SCOOP requirements.

## Recommended Order

1. Finding 1 (insertion_sort_range extraction) — highest code reduction, eliminates real duplication
2. Finding 2 (is_array_sorted delegation) — quick win, follows existing delegation pattern
3. Finding 4 (missing postconditions) — contract completeness, low risk
4. Finding 3 (dead branching) — cleanup, very low risk
5. Finding 5 (comparator_sort O(n^2)) — performance improvement, most effort

## What's Already Good

- SIMPLE_SORT_ALGORITHM as deferred ancestor with full MML contracts on `sort`
- Key extractor pattern (`FUNCTION [G, COMPARABLE]`) avoids constraining G
- swap and heapify correctly consolidated in ancestor (this session)
- Template Method for is_sorted/is_sorted_descending delegates to is_weakly_sorted_by_key (this session)
- SCOOP-compatible generic constraints on all classes (this session)
- Facade pattern: SIMPLE_SORTER delegates without inheriting from algorithms
