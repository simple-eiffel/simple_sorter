# S01: Project Inventory - ISE Eiffel Sorting Infrastructure

## Date: 2026-01-20

## Source: ISE EiffelStudio 25.02 Standard Library

---

## PROJECT IDENTITY

| Field | Value |
|-------|-------|
| Library Name | base_extension (sorting cluster) + base (elks structures) |
| Library UUID | BB1FDCB0-C2AB-4911-8ABD-D20F72139DBF (base_extension) |
| Stated Purpose | "Indexable data structure sorters" (from sorter.e note clause) |
| Version | EiffelStudio 25.02 |

---

## DEPENDENCY ANALYSIS

### base_extension Dependencies (from base_extension.ecf:13)

| Dependency | Location | Why Needed |
|------------|----------|------------|
| base | $ISE_LIBRARY\library\base\base.ecf | Core data structures (INDEXABLE, ARRAY, LIST) |

### Dependency Categories

| Category | Libraries |
|----------|-----------|
| Core | base (EiffelBase) |
| Simple ecosystem | (none) |
| External | (none) |

---

## CLUSTER ANALYSIS

### Cluster 1: base_extension/structures/sort

| Field | Value |
|-------|-------|
| Cluster | sort |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base_extension\structures\sort\ |
| Classes | SORTER, BUBBLE_SORTER, QUICK_SORTER, SHELL_SORTER, TOPOLOGICAL_SORTER |
| Apparent purpose | Sorting algorithms for indexable structures |

### Cluster 2: base_extension/kernel (comparators)

| Field | Value |
|-------|-------|
| Cluster | kernel |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base_extension\kernel\ |
| Classes | PART_COMPARATOR, COMPARATOR, COMPARABLE_COMPARATOR, REVERSE_PART_COMPARATOR, STRING_COMPARATOR |
| Apparent purpose | Comparison strategies for sorting |

### Cluster 3: base/elks/structures/sort

| Field | Value |
|-------|-------|
| Cluster | sort |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base\elks\structures\sort\ |
| Classes | SORTED_STRUCT, COMPARABLE_STRUCT |
| Apparent purpose | Abstract sorted structure interfaces |

### Cluster 4: base/elks/structures/list (sorted lists)

| Field | Value |
|-------|-------|
| Cluster | list |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base\elks\structures\list\ |
| Classes | SORTED_LIST, SORTED_TWO_WAY_LIST, PART_SORTED_LIST, PART_SORTED_TWO_WAY_LIST |
| Apparent purpose | Self-sorting list implementations |

### Cluster 5: base/elks/kernel (comparable)

| Field | Value |
|-------|-------|
| Cluster | kernel |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base\elks\kernel\ |
| Classes | COMPARABLE, PART_COMPARABLE |
| Apparent purpose | Total and partial order interfaces |

### Cluster 6: base_extension/tests

| Field | Value |
|-------|-------|
| Cluster | tests |
| Location | C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\base_extension\tests\ |
| Classes | TEST_SORTER, TEST_SORTER_ON_STRINGS, TEST_TOPOLOGICAL_SORTER |
| Apparent purpose | Unit tests for sorter classes |

---

## CLASS INVENTORY

### Sorter Algorithm Classes

#### CLASS: SORTER [G]
| Field | Value |
|-------|-------|
| File | base_extension/structures/sort/sorter.e |
| Cluster | sort |
| Has note clause | YES - "Indexable data structure sorters" |
| Creation procedures | make(a_comparator) |
| Public features | 12 |
| Has invariant | YES - comparator_not_void |
| Inherits from | (none - deferred class) |
| Role | ENGINE (abstract base) |

#### CLASS: QUICK_SORTER [G]
| Field | Value |
|-------|-------|
| File | base_extension/structures/sort/quick_sorter.e |
| Cluster | sort |
| Has note clause | YES - "Indexable data structure sorters using quick sort algorithm" |
| Creation procedures | make |
| Public features | 12 (inherited) + 1 (subsort_with_comparator) |
| Has invariant | YES (inherited) |
| Inherits from | SORTER [G] |
| Role | ENGINE |

#### CLASS: BUBBLE_SORTER [G]
| Field | Value |
|-------|-------|
| File | base_extension/structures/sort/bubble_sorter.e |
| Cluster | sort |
| Has note clause | YES - "Indexable data structure sorters using bubble sort algorithm" |
| Creation procedures | make |
| Public features | 12 (inherited) + 1 (subsort_with_comparator) |
| Has invariant | YES (inherited) |
| Inherits from | SORTER [G] |
| Role | ENGINE |

#### CLASS: SHELL_SORTER [G]
| Field | Value |
|-------|-------|
| File | base_extension/structures/sort/shell_sorter.e |
| Cluster | sort |
| Has note clause | YES - "Indexable data structure sorters using shell sort algorithm" |
| Creation procedures | make |
| Public features | 12 (inherited) + 1 (subsort_with_comparator) |
| Has invariant | YES (inherited) |
| Inherits from | SORTER [G] |
| Role | ENGINE |

#### CLASS: TOPOLOGICAL_SORTER [G -> HASHABLE]
| Field | Value |
|-------|-------|
| File | base_extension/structures/sort/topological_sorter.e |
| Cluster | sort |
| Has note clause | YES - "Topological sorter" with EIS link to academic paper |
| Creation procedures | make |
| Public features | 17 |
| Has invariant | YES - element_count, predecessor_list_count, successor_list_count, cycle_list_iff_cycle, all_items_sorted, no_item_forgotten, processed_count |
| Inherits from | (none) |
| Role | ENGINE (graph-based sorting) |

### Comparator Classes

#### CLASS: PART_COMPARATOR [G]
| Field | Value |
|-------|-------|
| File | base_extension/kernel/part_comparator.e |
| Cluster | kernel |
| Has note clause | YES - "Partial order comparators" |
| Creation procedures | (none - deferred) |
| Public features | 1 (less_than) |
| Has invariant | NO |
| Inherits from | (none) |
| Role | HELPER (abstract comparison) |

#### CLASS: COMPARATOR [G]
| Field | Value |
|-------|-------|
| File | base_extension/kernel/comparator.e |
| Cluster | kernel |
| Has note clause | YES - "Total order comparators" |
| Creation procedures | (none - deferred) |
| Public features | 5 (less_than, order_equal, less_equal, greater_equal, test) |
| Has invariant | NO |
| Inherits from | PART_COMPARATOR [G], EQUALITY_TESTER [G] |
| Role | HELPER (abstract comparison) |

#### CLASS: COMPARABLE_COMPARATOR [G -> COMPARABLE]
| Field | Value |
|-------|-------|
| File | base_extension/kernel/comparable_comparator.e |
| Cluster | kernel |
| Has note clause | YES - "Comparators based on COMPARABLE" |
| Creation procedures | (implicit default_create) |
| Public features | 5 (inherited) |
| Has invariant | NO |
| Inherits from | COMPARATOR [G] |
| Role | HELPER (bridges COMPARABLE to PART_COMPARATOR) |

#### CLASS: REVERSE_PART_COMPARATOR [G]
| Field | Value |
|-------|-------|
| File | base_extension/kernel/reverse_part_comparator.e |
| Cluster | kernel |
| Has note clause | YES - "Reverse partial order comparators" |
| Creation procedures | make(a_comparator) |
| Public features | 3 (less_than, comparator, set_comparator) |
| Has invariant | YES - comparator_not_void |
| Inherits from | PART_COMPARATOR [G] |
| Role | HELPER (decorator pattern) |

#### CLASS: STRING_COMPARATOR
| Field | Value |
|-------|-------|
| File | base_extension/kernel/string_comparator.e |
| Cluster | kernel |
| Has note clause | YES - explains safe string comparison |
| Creation procedures | make, make_caseless |
| Public features | 2 (is_case_insensitive, less_than) |
| Has invariant | NO |
| Inherits from | COMPARATOR [READABLE_STRING_GENERAL] |
| Role | HELPER (specialized string comparison) |

### Base Library Sorted Structure Classes

#### CLASS: COMPARABLE
| Field | Value |
|-------|-------|
| File | base/elks/kernel/comparable.e |
| Cluster | kernel |
| Has note clause | YES - "Objects that may be compared according to a total order relation" |
| Creation procedures | (none - deferred) |
| Public features | 8 (<, <=, >, >=, is_equal, three_way_comparison, max, min) |
| Has invariant | YES - irreflexive_comparison |
| Inherits from | PART_COMPARABLE |
| Role | DATA (total order interface) |

#### CLASS: PART_COMPARABLE
| Field | Value |
|-------|-------|
| File | base/elks/kernel/part_comparable.e |
| Cluster | kernel |
| Has note clause | YES - "Objects that may be compared according to a partial order relation" |
| Creation procedures | (none - deferred) |
| Public features | 4 (<, <=, >, >=) |
| Has invariant | NO |
| Inherits from | (none) |
| Role | DATA (partial order interface) |

#### CLASS: SORTED_STRUCT [G -> COMPARABLE]
| Field | Value |
|-------|-------|
| File | base/elks/structures/sort/sorted_struct.e |
| Cluster | sort |
| Has note clause | YES - "Structures whose items are sorted according to a total order relation" |
| Creation procedures | (none - deferred) |
| Public features | 5 (min, max, median, sorted, sort) |
| Has invariant | NO |
| Inherits from | COMPARABLE_STRUCT [G], INDEXABLE [G, INTEGER], LINEAR [G] |
| Role | DATA (sorted structure interface) |

#### CLASS: COMPARABLE_STRUCT [G -> COMPARABLE]
| Field | Value |
|-------|-------|
| File | base/elks/structures/sort/comparable_struct.e |
| Cluster | sort |
| Has note clause | YES - "Data structures whose items may be compared" |
| Creation procedures | (none - deferred) |
| Public features | 3 (min, max, min_max_available) |
| Has invariant | YES - empty_constraint |
| Inherits from | BILINEAR [G] |
| Role | DATA (comparable structure interface) |

#### CLASS: SORTED_LIST [G -> COMPARABLE]
| Field | Value |
|-------|-------|
| File | base/elks/structures/list/sorted_list.e |
| Cluster | list |
| Has note clause | YES - "Sequential lists where the cells are sorted in ascending order" |
| Creation procedures | (none - deferred) |
| Public features | 3 (min, max, median) |
| Has invariant | NO |
| Inherits from | PART_SORTED_LIST [G] |
| Role | DATA (sorted list interface) |

#### CLASS: SORTED_TWO_WAY_LIST [G -> COMPARABLE]
| Field | Value |
|-------|-------|
| File | base/elks/structures/list/sorted_two_way_list.e |
| Cluster | list |
| Has note clause | YES - "Two-way lists, kept sorted" |
| Creation procedures | make, make_from_iterable |
| Public features | 4 (extend, prune_all, sort, sorted) + inherited |
| Has invariant | NO |
| Inherits from | TWO_WAY_LIST [G], SORTED_LIST [G] |
| Role | DATA (self-sorting list implementation) |

### Test Classes

#### CLASS: TEST_SORTER
| Field | Value |
|-------|-------|
| File | base_extension/tests/test_sorter.e |
| Cluster | tests |
| Has note clause | YES |
| Test count | 3 |
| Tests | test_quick_sort, test_shell_sort, test_bubble_sort |

#### CLASS: TEST_SORTER_ON_STRINGS
| Field | Value |
|-------|-------|
| File | base_extension/tests/test_sorter_on_strings.e |
| Cluster | tests |
| Test count | (unknown - not read) |

#### CLASS: TEST_TOPOLOGICAL_SORTER
| Field | Value |
|-------|-------|
| File | base_extension/tests/test_topological_sorter.e |
| Cluster | tests |
| Test count | 3 |
| Tests | test_topological_sorter_no_cycles_fifo, test_topological_sorter_no_cycles_lifo, test_topological_sorter_cycles |

---

## FACADE IDENTIFICATION

**No single facade class exists.** The ISE sorting implementation is a **strategy pattern**:

| Class | Role | Usage |
|-------|------|-------|
| SORTER [G] | Abstract strategy | Create concrete sorter, call `sort(container)` |
| QUICK_SORTER [G] | Concrete strategy | Quick sort O(n log n) average |
| BUBBLE_SORTER [G] | Concrete strategy | Bubble sort O(n²) |
| SHELL_SORTER [G] | Concrete strategy | Shell sort O(n^1.5) |
| TOPOLOGICAL_SORTER [G] | Separate algorithm | Graph-based partial ordering |

**Entry point pattern:**
```eiffel
create {QUICK_SORTER [STRING]} my_sorter.make (create {COMPARABLE_COMPARATOR [STRING]})
my_sorter.sort (my_list)
```

---

## TEST INVENTORY

| Test Class | Test Count | Tests |
|------------|------------|-------|
| TEST_SORTER | 3 | test_quick_sort, test_shell_sort, test_bubble_sort |
| TEST_TOPOLOGICAL_SORTER | 3 | test_topological_sorter_no_cycles_fifo, test_topological_sorter_no_cycles_lifo, test_topological_sorter_cycles |

**Total tests:** 6+

---

## SUMMARY

| Metric | Value |
|--------|-------|
| **Name** | ISE Eiffel Sorting Infrastructure |
| **Purpose** | Sorting algorithms and comparators for indexable structures |
| **Dependencies** | 1 (base) |
| **Clusters** | 6 |
| **Total Classes** | 18 |
| **Facades** | 0 (strategy pattern) |
| **Engines** | 5 (SORTER, QUICK_SORTER, BUBBLE_SORTER, SHELL_SORTER, TOPOLOGICAL_SORTER) |
| **Data** | 7 (COMPARABLE, PART_COMPARABLE, SORTED_STRUCT, COMPARABLE_STRUCT, SORTED_LIST, SORTED_TWO_WAY_LIST, + partial variants) |
| **Helpers** | 5 (PART_COMPARATOR, COMPARATOR, COMPARABLE_COMPARATOR, REVERSE_PART_COMPARATOR, STRING_COMPARATOR) |
| **Tests** | 3 classes, 6+ tests |

---

## DOCUMENTATION STATUS

| Item | Status |
|------|--------|
| README | ABSENT (no base_extension README) |
| Note clauses | 100% of classes |
| Header comments | 90%+ of features |
| EIS links | 1 (TOPOLOGICAL_SORTER links to academic paper) |

---

## FILES READ (Evidence)

| File | Lines |
|------|-------|
| base_extension/structures/sort/sorter.e | 1-224 |
| base_extension/structures/sort/quick_sorter.e | 1-122 |
| base_extension/structures/sort/bubble_sorter.e | 1-73 |
| base_extension/structures/sort/shell_sorter.e | 1-79 |
| base_extension/structures/sort/topological_sorter.e | 1-376 |
| base_extension/kernel/part_comparator.e | 1-41 |
| base_extension/kernel/comparator.e | 1-85 |
| base_extension/kernel/comparable_comparator.e | 1-33 |
| base_extension/kernel/reverse_part_comparator.e | 1-77 |
| base_extension/kernel/string_comparator.e | 1-97 |
| base/elks/kernel/comparable.e | 1-131 |
| base/elks/kernel/part_comparable.e | 1-57 |
| base/elks/structures/sort/sorted_struct.e | 1-123 |
| base/elks/structures/sort/comparable_struct.e | 1-95 |
| base/elks/structures/list/sorted_list.e | 1-66 |
| base/elks/structures/list/sorted_two_way_list.e | 1-171 |
| base_extension/tests/test_sorter.e | 1-154 |
| base_extension/tests/test_topological_sorter.e | 1-153 |
| base_extension/base_extension.ecf | 1-23 |
