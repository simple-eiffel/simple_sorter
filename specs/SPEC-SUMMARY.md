# ISE Eiffel Sorting Infrastructure - Extracted Specification

## Date: 2026-01-20
## Source: EiffelStudio 25.02 Standard Library (base + base_extension)

---

# 1. Executive Summary

The ISE Eiffel sorting infrastructure provides **multiple sorting algorithms** for indexable data structures through a **strategy pattern**. Users create a concrete sorter (QUICK_SORTER, BUBBLE_SORTER, or SHELL_SORTER), provide a comparator defining the ordering, and call `sort` on any INDEXABLE container.

**Key Capabilities:**
- Quick sort (O(n log n) average) - fast general-purpose sorting
- Shell sort (O(n^1.5)) - good for medium-sized data
- Bubble sort (O(n²)) - simple, works well for nearly-sorted data
- Topological sort - dependency ordering for DAGs
- Reverse sorting via comparator decoration
- String comparison with case-sensitivity options
- Self-sorting lists that maintain order on insertion

**Design Principles:**
- Strategy pattern separates algorithms from comparison logic
- Decorator pattern for reverse ordering
- Adapter pattern bridges COMPARABLE to comparators
- Template method defines sorting skeleton
- Full Design by Contract with pre/postconditions

**Quality Guarantees:**
- Postcondition guarantees sorted output
- Invariants protect internal consistency
- Cycle detection in topological sorting
- 100% note clause coverage

---

# 2. Scope and Purpose

## PURPOSE

The ISE Eiffel sorting infrastructure provides **in-place sorting algorithms** for **Eiffel collections** by **applying the strategy pattern to separate comparison from algorithm**.

## SCOPE

### In Scope
- Sorting INDEXABLE containers (arrays, lists)
- Total order (COMPARABLE) and partial order (PART_COMPARABLE) comparison
- Ascending and descending sort order
- Subsort (sort a range within container)
- Topological sorting of dependency graphs
- Self-sorting list structures

### Out of Scope
- External/disk-based sorting (large datasets)
- Merge sort algorithm
- Heap sort algorithm
- Radix sort (non-comparison based)
- Parallel/concurrent sorting
- Sorting of non-INDEXABLE structures (trees, graphs)

## ASSUMPTIONS
- Container supports integer indexing
- Container elements are non-void (comparator requires non-void)
- Comparison is consistent (transitive, asymmetric)
- Container is modifiable (can swap elements)

---

# 3. Domain Model

## Core Concepts

| Concept | Definition |
|---------|------------|
| Sorter | Algorithm that rearranges container elements into order |
| Comparator | Strategy defining less-than relationship |
| Sorted State | All elements satisfy: item[i] <= item[i+1] |
| Topological Order | Linear order respecting dependencies |

## Relationships

```
SORTER [G] ─────uses─────> PART_COMPARATOR [G]
    │                              △
    │ inherits                     │ inherits
    ▼                              │
QUICK_SORTER [G]          COMPARATOR [G]
BUBBLE_SORTER [G]                  │ inherits
SHELL_SORTER [G]                   ▼
                          COMPARABLE_COMPARATOR [G -> COMPARABLE]
```

## Domain Vocabulary

| Term | Meaning |
|------|---------|
| sort(container) | Rearrange into ascending order |
| reverse_sort(container) | Rearrange into descending order |
| subsort(container, lower, upper) | Sort only the range |
| sorted(container) | Query: is it in ascending order? |
| less_than(a, b) | Comparator query: is a < b? |

---

# 4. System Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                    CLIENT CODE                                 │
└───────────────────────────────┬───────────────────────────────┘
                                │ creates
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                  SORTER [G] (deferred)                        │
│  - make(a_comparator)                                         │
│  - sort(a_container)                                          │
│  - sorted(a_container): BOOLEAN                               │
│  - subsort(a_container, lower, upper)                         │
└─────────────────────────┬─────────────────────────────────────┘
                          │ implemented by
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│ QUICK_SORTER  │ │ BUBBLE_SORTER │ │ SHELL_SORTER  │
│ O(n log n)    │ │ O(n²)         │ │ O(n^1.5)      │
└───────────────┘ └───────────────┘ └───────────────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │ uses
                          ▼
┌───────────────────────────────────────────────────────────────┐
│              PART_COMPARATOR [G] (deferred)                   │
│  - less_than(u, v): BOOLEAN                                   │
└─────────────────────────┬─────────────────────────────────────┘
                          │ implemented by
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
┌───────────────────┐ ┌───────────────────┐ ┌───────────────────┐
│ COMPARABLE_       │ │ STRING_           │ │ REVERSE_PART_     │
│ COMPARATOR        │ │ COMPARATOR        │ │ COMPARATOR        │
│ [G->COMPARABLE]   │ │                   │ │ (decorator)       │
└───────────────────┘ └───────────────────┘ └───────────────────┘
```

## Component Responsibilities

| Component | Responsibility |
|-----------|---------------|
| SORTER | Define sorting interface; manage comparator; provide sorted query |
| QUICK_SORTER | Implement quicksort with partition scheme |
| BUBBLE_SORTER | Implement bubble sort with early termination |
| SHELL_SORTER | Implement shell sort with gap sequence |
| PART_COMPARATOR | Define comparison interface |
| COMPARABLE_COMPARATOR | Adapt COMPARABLE to comparator |
| REVERSE_PART_COMPARATOR | Invert ordering for descending sort |
| STRING_COMPARATOR | Unicode-aware string comparison |
| TOPOLOGICAL_SORTER | Convert partial order to total order |

---

# 5. Class Specifications

## SORTER [G]

**Purpose:** Abstract base for sorting algorithms

**Invariant:**
```eiffel
invariant
  comparator_not_void: comparator /= Void
```

### Creation

| Procedure | Purpose | Precondition | Postcondition |
|-----------|---------|--------------|---------------|
| make(a_comparator) | Create sorter with comparison strategy | a_comparator /= Void | comparator = a_comparator |

### Queries

| Feature | Returns | Purpose | Precondition |
|---------|---------|---------|--------------|
| comparator | PART_COMPARATOR [G] | Current comparison strategy | (none) |
| sorted(a_container) | BOOLEAN | Is container sorted ascending? | is_sortable_container(a_container) |
| reverse_sorted(a_container) | BOOLEAN | Is container sorted descending? | is_sortable_container(a_container) |
| subsorted(a_container, lower, upper) | BOOLEAN | Is range sorted? | valid bounds |

### Commands

| Feature | Purpose | Precondition | Postcondition |
|---------|---------|--------------|---------------|
| sort(a_container) | Sort ascending | is_sortable_container | sorted(a_container) |
| reverse_sort(a_container) | Sort descending | is_sortable_container | reverse_sorted(a_container) |
| subsort(a_container, lower, upper) | Sort range | valid bounds | subsorted(a_container, lower, upper) |

---

## QUICK_SORTER [G]

**Purpose:** Quick sort implementation (O(n log n) average, O(n²) worst)

**Inherits:** SORTER [G]

**Algorithm:** Partition-based. Uses middle element as pivot. Non-recursive (iterative with explicit stack).

---

## BUBBLE_SORTER [G]

**Purpose:** Bubble sort implementation (O(n²))

**Inherits:** SORTER [G]

**Algorithm:** Adjacent comparison with early termination. Tracks if any swap occurred; stops if no swaps in a pass.

---

## SHELL_SORTER [G]

**Purpose:** Shell sort implementation (O(n^1.5))

**Inherits:** SORTER [G]

**Algorithm:** Gap-based insertion sort. Gap starts at count/2 and halves each iteration.

---

## PART_COMPARATOR [G]

**Purpose:** Define partial order comparison interface

**Queries:**

| Feature | Returns | Purpose | Precondition | Postcondition |
|---------|---------|---------|--------------|---------------|
| less_than(u, v) | BOOLEAN | Is u < v? | u /= Void, v /= Void | asymmetric: Result implies not less_than(v, u) |

---

## COMPARABLE_COMPARATOR [G -> COMPARABLE]

**Purpose:** Adapter from COMPARABLE to PART_COMPARATOR

**Implementation:**
```eiffel
less_than (u, v: G): BOOLEAN
  do
    Result := u < v
  end
```

---

## TOPOLOGICAL_SORTER [G -> HASHABLE]

**Purpose:** Produce total order from partial order (dependency resolution)

**Invariants:**
```eiffel
invariant
  element_count: element_of_index.count = count
  predecessor_list_count: predecessor_count.count = count
  successor_list_count: successors.count = count
  cycle_list_iff_cycle: done implies (cycle_found = (not cycle_list.is_empty))
  all_items_sorted: (done and not cycle_found) implies (count = sorted_elements.count)
  no_item_forgotten: (done and cycle_found) implies (count = sorted_elements.count + cycle_list.count)
```

### Commands

| Feature | Purpose | Precondition | Postcondition |
|---------|---------|--------------|---------------|
| record_element(e) | Add element to set | not done | (element recorded) |
| record_constraint(e, f) | Add constraint e before f | not done | (constraint recorded) |
| process | Perform topological sort | not done | done |

### Queries

| Feature | Returns | Purpose | Precondition |
|---------|---------|---------|--------------|
| sorted_elements | LIST [G] | Ordered elements | done |
| cycle_found | BOOLEAN | Was there a cycle? | done |
| cycle_list | LIST [G] | Elements in cycles | done |

---

# 6. Behavioral Specifications

## Workflow: Sort a Container

**Purpose:** Rearrange container elements into sorted order

**Steps:**
1. Create comparator for element type
2. Create sorter with comparator
3. Call sort(container)
4. Container is now sorted (postcondition guarantees)

**Preconditions:**
- Container is INDEXABLE [G, INTEGER]
- Container elements are non-void
- Comparator defines valid ordering

**Postconditions:**
- For all i in [lower, upper-1]: comparator.less_than(item[i+1], item[i]) = False

---

## Workflow: Topological Sort

**Purpose:** Order elements respecting dependency constraints

**Steps:**
1. Create TOPOLOGICAL_SORTER
2. Record elements with record_element(e)
3. Record constraints with record_constraint(e, f) for "e before f"
4. Call process
5. Check cycle_found
6. If no cycles, sorted_elements contains valid ordering

**Preconditions:**
- Elements are HASHABLE

**Postconditions:**
- If no cycles: all elements appear in sorted_elements
- If cycles: cycle_list contains elements involved
- sorted_elements.count + cycle_list.count = total elements

---

# 7. Constraints

## Integrity Rules

| ID | Rule | Source |
|----|------|--------|
| I1 | Comparator must be non-void throughout sorter lifetime | sorter.e invariant |
| I2 | Elements compared must be non-void | part_comparator.e:16-17 |
| I3 | Topological sorter element counts must match | topological_sorter.e invariants |

## Validity Rules

| ID | Rule | Source |
|----|------|--------|
| V1 | Subsort bounds must be valid indices | sorter.e:169-171 |
| V2 | Lower must be <= upper for subsort | sorter.e:172 |
| V3 | Container must be sortable (non-void, indexable) | sorter.e:31-33 |

## Comparison Rules

| ID | Rule | Source |
|----|------|--------|
| C1 | less_than is asymmetric: a < b implies not (b < a) | part_comparator.e:20-21 |
| C2 | Comparison is irreflexive: not (a < a) | comparable.e:114 |

---

# 8. Boundary Conditions

| Condition | Behavior | Evidence |
|-----------|----------|----------|
| Empty container | sorted returns True, sort does nothing | sorter.e:63 (is_empty check) |
| Single element | sorted returns True, sort does nothing | Implicit from algorithm |
| Already sorted | Quick detection possible, no swaps needed | bubble_sorter.e:46-50 (flipped flag) |
| Reverse sorted | Worst case for some algorithms | Known quicksort worst case |
| All equal elements | Sorted, minimal work | Comparison < returns False |
| Topological cycles | cycle_found = True, cycle_list populated | topological_sorter.e:305-325 |

---

# 9. Error Handling

| Error Condition | Handling | Source |
|-----------------|----------|--------|
| Void comparator | Precondition violation at creation | sorter.e:16 |
| Void container | Precondition violation at sort | Implicit from is_sortable_container |
| Invalid bounds | Precondition violation at subsort | sorter.e:169-172 |
| Topological cycle | cycle_found = True, partial result in sorted_elements | topological_sorter.e invariants |

**Note:** ISE sorters rely on Design by Contract. Invalid inputs cause precondition violations (assertion failures in debug mode).

---

# 10. Quality Attributes

| Attribute | Assessment | Evidence |
|-----------|------------|----------|
| **Void Safety** | PARTIAL | Comparators require non-void args, but not all classes use attached/detachable keywords |
| **SCOOP Compatibility** | UNKNOWN | No separate keywords observed; likely not thread-safe |
| **Testability** | MEDIUM | Tests exist but coverage is limited (6 tests for complex algorithms) |
| **Contract Coverage** | HIGH | 90%+ features have contracts; strong postconditions on sort operations |
| **Documentation** | HIGH | 100% note clauses; algorithm references in comments |

---

# 11. Open Questions

1. **Why no merge sort?** Memory efficiency concern, or oversight?
2. **Why no heap sort?** HEAP_PRIORITY_QUEUE exists but no sorter uses it
3. **Stability?** Are equal elements preserved in original order? (Not documented)
4. **Thread safety?** Can sorters be used from multiple SCOOP regions?
5. **Performance on nearly-sorted data?** Is there adaptive behavior?
6. **Why TOPOLOGICAL_SORTER doesn't inherit SORTER?** Different interface paradigm?

---

# Appendix A: Contract Gaps

| Class | Feature | Missing Contract |
|-------|---------|------------------|
| QUICK_SORTER | subsort_with_comparator | No intermediate postcondition (only inherited) |
| BUBBLE_SORTER | subsort_with_comparator | No intermediate postcondition (only inherited) |
| SHELL_SORTER | subsort_with_comparator | No intermediate postcondition (only inherited) |
| STRING_COMPARATOR | less_than | No explicit asymmetry postcondition |

---

# Appendix B: Test Coverage Gaps

| Algorithm | Tested | Missing Tests |
|-----------|--------|---------------|
| Quick sort | Basic sort | Empty, single element, worst case, stability |
| Bubble sort | Basic sort | Empty, single element, early termination |
| Shell sort | Basic sort | Empty, single element, gap sequence validation |
| Topological | Cycles, no cycles | Empty graph, single node, disconnected components |

---

# Appendix C: Files Analyzed

| File | Lines | Content |
|------|-------|---------|
| sorter.e | 224 | Base class with 12 public features |
| quick_sorter.e | 122 | Quicksort implementation |
| bubble_sorter.e | 73 | Bubble sort implementation |
| shell_sorter.e | 79 | Shell sort implementation |
| topological_sorter.e | 376 | Topological sort with cycle detection |
| part_comparator.e | 41 | Partial order interface |
| comparator.e | 85 | Total order interface |
| comparable_comparator.e | 33 | COMPARABLE adapter |
| reverse_part_comparator.e | 77 | Reverse ordering decorator |
| string_comparator.e | 97 | String comparison with case options |
| comparable.e | 131 | Total order interface (base library) |
| part_comparable.e | 57 | Partial order interface (base library) |
| sorted_struct.e | 123 | Sorted structure interface |
| comparable_struct.e | 95 | Comparable structure interface |
| sorted_list.e | 66 | Sorted list interface |
| sorted_two_way_list.e | 171 | Self-sorting list implementation |
| test_sorter.e | 154 | Sorter tests |
| test_topological_sorter.e | 153 | Topological sorter tests |
| base_extension.ecf | 23 | Library configuration |
