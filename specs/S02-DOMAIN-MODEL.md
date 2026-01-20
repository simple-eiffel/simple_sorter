# S02: Domain Model - ISE Eiffel Sorting Infrastructure

## Date: 2026-01-20

## Input: S01-INVENTORY-PROJECT.md

---

## PROBLEM DOMAIN

The ISE Eiffel sorting infrastructure addresses the problem of **ordering elements in indexable data structures**. It provides multiple sorting algorithms (quick sort, bubble sort, shell sort) through a strategy pattern, allowing users to choose the appropriate algorithm for their performance needs. Additionally, it handles **topological ordering** for directed acyclic graphs to establish dependency order. The library separates comparison logic from sorting algorithms, enabling custom ordering without modifying sorter implementations.

---

## CORE CONCEPTS

| Concept | Definition |
|---------|------------|
| **Sorter** | An algorithm that rearranges elements in a container according to a total or partial order |
| **Comparator** | A strategy object that defines how two elements should be compared (less than relationship) |
| **Indexable Container** | A data structure with integer-indexed access (arrays, lists) |
| **Total Order** | A comparison where every pair of elements is comparable (COMPARABLE) |
| **Partial Order** | A comparison where some pairs may be incomparable (PART_COMPARABLE) |
| **Sorted State** | A container where each element is less-than-or-equal to its successor |
| **Topological Order** | A linear ordering of graph nodes where each node appears before all its successors |
| **Constraint** | A directed relationship in topological sorting (A must come before B) |
| **Cycle** | A circular dependency in topological sorting that prevents valid ordering |

---

## NAMING CONVENTION ANALYSIS

| Pattern | Classes | Meaning |
|---------|---------|---------|
| `{X}_SORTER` | SORTER, QUICK_SORTER, BUBBLE_SORTER, SHELL_SORTER, TOPOLOGICAL_SORTER | Algorithm that sorts |
| `{X}_COMPARATOR` | PART_COMPARATOR, COMPARATOR, COMPARABLE_COMPARATOR, STRING_COMPARATOR | Comparison strategy |
| `REVERSE_{X}` | REVERSE_PART_COMPARATOR | Inverts another object's behavior |
| `SORTED_{X}` | SORTED_STRUCT, SORTED_LIST, SORTED_TWO_WAY_LIST | Self-maintaining sorted structure |
| `COMPARABLE_{X}` | COMPARABLE_STRUCT, COMPARABLE_COMPARATOR | Bridges COMPARABLE interface |
| `PART_{X}` | PART_COMPARABLE, PART_COMPARATOR, PART_SORTED_LIST | Partial order variant |

---

## RELATIONSHIPS

```
┌─────────────────────────────────────────────────────────────────┐
│                    SORTING ALGORITHM DOMAIN                     │
└─────────────────────────────────────────────────────────────────┘

                         ┌──────────────────┐
                         │     SORTER [G]   │ (abstract)
                         │   - comparator   │
                         │   - sort()       │
                         │   - sorted?      │
                         └────────┬─────────┘
                                  │ inherits
          ┌───────────────────────┼───────────────────────┐
          │                       │                       │
          ▼                       ▼                       ▼
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  QUICK_SORTER   │   │  BUBBLE_SORTER  │   │  SHELL_SORTER   │
│  O(n log n)     │   │  O(n²)          │   │  O(n^1.5)       │
└─────────────────┘   └─────────────────┘   └─────────────────┘

          │                       │                       │
          └───────────────────────┼───────────────────────┘
                                  │ uses
                                  ▼
                    ┌──────────────────────────┐
                    │  PART_COMPARATOR [G]     │ (abstract)
                    │  - less_than(u, v)       │
                    └────────────┬─────────────┘
                                 │ inherits
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
          ▼                      ▼                      ▼
┌─────────────────┐  ┌───────────────────┐  ┌─────────────────────┐
│  COMPARATOR [G] │  │ REVERSE_PART_     │  │                     │
│  (total order)  │  │ COMPARATOR [G]    │  │                     │
└────────┬────────┘  │ - wraps another   │  │                     │
         │           └───────────────────┘  │                     │
         │ inherits                         │                     │
         ▼                                  │                     │
┌────────────────────┐                      │                     │
│ COMPARABLE_        │                      │                     │
│ COMPARATOR         │                      │                     │
│ [G -> COMPARABLE]  │                      │                     │
└────────────────────┘                      │                     │
                                            │                     │
┌────────────────────┐                      │                     │
│ STRING_COMPARATOR  │──────────────────────┘                     │
│ - case options     │                                            │
└────────────────────┘                                            │
                                                                  │
                    ┌─────────────────────────────────────────────┘
                    │
                    │ sorts
                    ▼
          ┌──────────────────────────┐
          │  INDEXABLE [G, INTEGER]  │ (from base)
          │  - arrays, lists         │
          └──────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                   TOPOLOGICAL SORTING DOMAIN                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│     TOPOLOGICAL_SORTER [G -> HASHABLE]  │
│     - record_element(e)                 │
│     - record_constraint(e, f)           │
│     - process()                         │
│     - sorted_elements                   │
│     - cycle_found?                      │
│     - cycle_list                        │
└─────────────────────────────────────────┘
          │
          │ produces
          ▼
┌─────────────────────────────────────────┐
│  LIST [G]  (sorted_elements)            │
│  LIST [G]  (cycle_list if cycles found) │
└─────────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                   SELF-SORTING STRUCTURES                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────┐
│     SORTED_STRUCT [G -> COMPARABLE]  │
│     - sort()                         │
│     - sorted?                        │
│     - min, max, median               │
└──────────────────────────────────────┘
          │
          │ inherits
          ▼
┌──────────────────────────────────────┐
│  SORTED_TWO_WAY_LIST [G -> COMPARABLE] │
│  - uses comb sort internally         │
│  - extend() maintains order          │
└──────────────────────────────────────┘
```

---

## RELATIONSHIP TABLE

| From | Relationship | To | Evidence |
|------|--------------|-----|----------|
| SORTER | has-a | PART_COMPARATOR | sorter.e:25 - `comparator: PART_COMPARATOR [G]` |
| QUICK_SORTER | is-a | SORTER | quick_sorter.e:12 - `inherit SORTER [G]` |
| BUBBLE_SORTER | is-a | SORTER | bubble_sorter.e:12 - `inherit SORTER [G]` |
| SHELL_SORTER | is-a | SORTER | shell_sorter.e:12 - `inherit SORTER [G]` |
| SORTER | operates-on | INDEXABLE [G, INTEGER] | sorter.e:128 - `sort (a_container: INDEXABLE [G, INTEGER])` |
| SORTER | creates | REVERSE_PART_COMPARATOR | sorter.e:52 - `create {REVERSE_PART_COMPARATOR [G]}.make (comparator)` |
| COMPARATOR | is-a | PART_COMPARATOR | comparator.e:12 - `inherit PART_COMPARATOR [G]` |
| COMPARABLE_COMPARATOR | is-a | COMPARATOR | comparable_comparator.e:12 - `inherit COMPARATOR [G]` |
| STRING_COMPARATOR | is-a | COMPARATOR | string_comparator.e:16 - `inherit COMPARATOR [...]` |
| REVERSE_PART_COMPARATOR | wraps | PART_COMPARATOR | reverse_part_comparator.e:41 - `comparator: PART_COMPARATOR [G]` |
| TOPOLOGICAL_SORTER | produces | LIST [G] | topological_sorter.e:99 - `sorted_elements: LIST [G]` |
| SORTED_TWO_WAY_LIST | is-a | TWO_WAY_LIST | sorted_two_way_list.e:15 - `inherit TWO_WAY_LIST [G]` |
| SORTED_TWO_WAY_LIST | is-a | SORTED_LIST | sorted_two_way_list.e:22 - `SORTED_LIST [G]` |

---

## VOCABULARY

| Term | Source | Definition |
|------|--------|------------|
| `sort` | SORTER.sort | Rearrange elements into ascending order |
| `reverse_sort` | SORTER.reverse_sort | Rearrange elements into descending order |
| `subsort` | SORTER.subsort | Sort only a portion of the container (lower..upper) |
| `sorted` | SORTER.sorted | Query: are elements in ascending order? |
| `less_than` | PART_COMPARATOR.less_than | Compare two elements, return True if first is strictly less |
| `comparator` | SORTER.comparator | The comparison strategy used by the sorter |
| `constraint` | TOPOLOGICAL_SORTER.record_constraint | A pair (e, f) meaning e must come before f |
| `cycle` | TOPOLOGICAL_SORTER.cycle_found | A circular dependency preventing valid topological order |
| `candidates` | TOPOLOGICAL_SORTER internal | Elements with no remaining predecessors, ready to be output |
| `pivot` | QUICK_SORTER internal | Element used to partition array in quicksort |
| `gap` | SHELL_SORTER internal | Distance between compared elements (shrinks each pass) |
| `flipped` | BUBBLE_SORTER internal | Flag indicating a swap occurred (optimization) |

---

## RESPONSIBILITIES

| Class | Primary Responsibility |
|-------|----------------------|
| **SORTER [G]** | Define sorting algorithm interface; provide sort/sorted queries; manage comparator |
| **QUICK_SORTER [G]** | Implement quicksort algorithm (partition-based, O(n log n) average) |
| **BUBBLE_SORTER [G]** | Implement bubble sort algorithm (swap-based, O(n²)) |
| **SHELL_SORTER [G]** | Implement shell sort algorithm (gap-based insertion sort, O(n^1.5)) |
| **TOPOLOGICAL_SORTER [G]** | Produce total ordering from partial ordering (dependency resolution) |
| **PART_COMPARATOR [G]** | Define partial order comparison interface (less_than) |
| **COMPARATOR [G]** | Extend partial order to total order (order_equal, less_equal, greater_equal) |
| **COMPARABLE_COMPARATOR [G]** | Adapt COMPARABLE objects to PART_COMPARATOR interface |
| **REVERSE_PART_COMPARATOR [G]** | Invert a comparator's ordering (for descending sorts) |
| **STRING_COMPARATOR** | Compare strings with case-sensitivity options |
| **SORTED_TWO_WAY_LIST [G]** | Maintain sorted order on insertions; provide O(1) min/max |

---

## DOMAIN INVARIANTS

### SORTER Invariants

| Invariant | Source | Domain Meaning |
|-----------|--------|----------------|
| `comparator_not_void` | sorter.e:210 | A sorter must always have a comparison strategy |

### TOPOLOGICAL_SORTER Invariants

| Invariant | Source | Domain Meaning |
|-----------|--------|----------------|
| `element_count: element_of_index.count = count` | topological_sorter.e:354 | All recorded elements are tracked |
| `cycle_list_iff_cycle: done implies (cycle_found = (not cycle_list.is_empty))` | topological_sorter.e:359 | Cycles reported correctly |
| `all_items_sorted: (done and not cycle_found) implies (count = sorted_elements.count)` | topological_sorter.e:361 | All elements appear in output when no cycles |
| `no_item_forgotten: (done and cycle_found) implies (count = sorted_elements.count + cycle_list.count)` | topological_sorter.e:362 | Elements are either sorted or in a cycle |

### REVERSE_PART_COMPARATOR Invariants

| Invariant | Source | Domain Meaning |
|-----------|--------|----------------|
| `comparator_not_void` | reverse_part_comparator.e:57 | Decorator must wrap a valid comparator |

### COMPARABLE Invariants

| Invariant | Source | Domain Meaning |
|-----------|--------|----------------|
| `irreflexive_comparison: not (Current < Current)` | comparable.e:114 | Nothing is less than itself |

---

## DOMAIN RULES

1. **Asymmetry of less_than**: If `a < b` then `not (b < a)` (from PART_COMPARATOR postcondition, line 20-21)

2. **Sorted postcondition**: After `sort(container)`, the container satisfies `sorted(container)` (from SORTER postcondition, line 135-136)

3. **Comparator required**: A sorter cannot operate without a comparison strategy (invariant enforced)

4. **Topological constraints are directed**: `record_constraint(e, f)` means e must come before f, not symmetric

5. **Cycles prevent complete ordering**: If a cycle exists, not all elements can appear in sorted_elements

6. **Empty containers are sorted**: An empty container trivially satisfies the sorted property

7. **Bounds preservation**: subsort(lower, upper) only modifies elements within those bounds

8. **Comb sort for sorted lists**: SORTED_TWO_WAY_LIST uses comb sort (O(n log n)) not quicksort

---

## OPEN QUESTIONS

1. **Why no merge sort?** The ISE library provides quick, bubble, and shell sorts but no merge sort. Is this by design (memory overhead) or an oversight?

2. **Why separate PART_COMPARATOR and COMPARATOR?** The distinction between partial and total orders seems rarely used in practice. Most sorting requires total order.

3. **Why TOPOLOGICAL_SORTER is not a SORTER?** It doesn't inherit from SORTER even though it performs sorting. The interfaces are completely different.

4. **Why no heap sort?** HEAP_PRIORITY_QUEUE exists but there's no corresponding heap sorter.

5. **Stability not guaranteed?** None of the sorters document whether they preserve the relative order of equal elements.

6. **Thread safety?** No SCOOP annotations visible. Are these sorters safe for concurrent use?

---

## DESIGN PATTERNS OBSERVED

| Pattern | Where | Purpose |
|---------|-------|---------|
| **Strategy** | SORTER + PART_COMPARATOR | Separate algorithm from comparison |
| **Template Method** | SORTER.sort → subsort_with_comparator | Define algorithm skeleton, defer details |
| **Decorator** | REVERSE_PART_COMPARATOR | Modify comparator behavior without subclassing |
| **Adapter** | COMPARABLE_COMPARATOR | Bridge COMPARABLE to PART_COMPARATOR interface |
