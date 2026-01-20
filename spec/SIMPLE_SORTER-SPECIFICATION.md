# simple_sorter Specification

## Version: 1.0.0 (Draft)
## Date: 2026-01-20

---

# 1. Overview

## Purpose

**simple_sorter** provides modern, ergonomic sorting operations for Eiffel collections. It eliminates the need for explicit comparator classes by using agent-based comparison, while offering multiple algorithm choices and stable sorting options.

## Scope

### In Scope
- Sorting arrays and lists (ARRAY, ARRAYED_LIST, LIST)
- Agent-based comparison (sort_by key function)
- Multiple algorithms (quick, merge, heap, insertion)
- Stable and unstable sorting
- Ascending and descending order
- Partial sorting (first N elements)
- Key caching for expensive computations

### Out of Scope
- External/disk-based sorting
- Parallel/SCOOP sorting (deferred to v2.0)
- Non-linear structure sorting (trees, graphs)

## Class Summary

| Class | Role | Responsibility |
|-------|------|----------------|
| SIMPLE_SORTER [G] | FACADE | Main entry point; provides all sorting operations |
| SIMPLE_SORT_ALGORITHM [G] | ENGINE | Deferred base for algorithm implementations |
| SIMPLE_INTROSORT [G] | ENGINE | Hybrid quick/heap/insertion sort (default) |
| SIMPLE_MERGE_SORT [G] | ENGINE | Stable O(n log n) merge sort |
| SIMPLE_HEAP_SORT [G] | ENGINE | In-place O(n log n) heap sort |
| SIMPLE_INSERTION_SORT [G] | ENGINE | Simple O(n²) for small/nearly-sorted |

## Quick Start

```eiffel
local
    sorter: SIMPLE_SORTER [PERSON]
    people: ARRAYED_LIST [PERSON]
do
    create sorter

    -- Sort by name (ascending)
    sorter.sort_by (people, agent {PERSON}.name)

    -- Sort by age (descending)
    sorter.sort_by_descending (people, agent {PERSON}.age)

    -- Stable sort preserves order of equal elements
    sorter.sort_by_stable (people, agent {PERSON}.department)
end
```

---

# 2. Domain Model

## Problem Domain

Sorting is the process of arranging elements in a specific order. The domain involves:
- **Elements**: Objects to be ordered
- **Keys**: Values used for comparison (may be derived from elements)
- **Comparisons**: Determining relative order of two elements
- **Algorithms**: Strategies for efficiently achieving sorted order

## Core Concepts

### Sorter
- **Definition**: An object that can rearrange elements of a container into sorted order
- **Properties**: Has a current algorithm, can query sorted state
- **Rules**: Container must be modifiable, elements must yield valid keys

### Key Function
- **Definition**: An agent that extracts a COMPARABLE value from an element
- **Properties**: Returns same key for same element (pure function)
- **Rules**: Key values must be non-void

### Sorted Order
- **Definition**: A sequence where each element's key is ≤ the next element's key
- **Properties**: Transitive, total order
- **Rules**: Empty and single-element sequences are trivially sorted

### Stable Sort
- **Definition**: A sort that preserves the relative order of elements with equal keys
- **Properties**: Deterministic for equal elements
- **Rules**: Original order is the tie-breaker

## Relationships

```
SIMPLE_SORTER [G]
    │
    ├── uses ──> SIMPLE_SORT_ALGORITHM [G]
    │                    │
    │                    ├── SIMPLE_INTROSORT [G]
    │                    ├── SIMPLE_MERGE_SORT [G]
    │                    ├── SIMPLE_HEAP_SORT [G]
    │                    └── SIMPLE_INSERTION_SORT [G]
    │
    ├── operates on ──> INDEXABLE [G, INTEGER]
    │                    │
    │                    ├── ARRAY [G]
    │                    └── ARRAYED_LIST [G]
    │
    └── uses ──> FUNCTION [G, COMPARABLE]  (key function)
```

## Domain Rules

| ID | Rule | Enforced By |
|----|------|-------------|
| DR-001 | Key function must return non-void | SIMPLE_SORTER precondition |
| DR-002 | After sort, container is sorted | SIMPLE_SORTER postcondition |
| DR-003 | Stable sort preserves equal-key order | SIMPLE_MERGE_SORT guarantee |
| DR-004 | Sort does not change element count | SIMPLE_SORTER postcondition |

---

# 3. Class Specifications

## SIMPLE_SORTER [G]

### Identity
- **Name**: SIMPLE_SORTER [G]
- **Role**: FACADE
- **Responsibility**: Provide all sorting operations with clean API

### Genericity
```eiffel
class SIMPLE_SORTER [G]
```
No constraint on G - any element type allowed.

### Creation

```eiffel
make
    -- Create sorter with default algorithm (introsort).
  ensure
    algorithm_set: algorithm /= Void
    default_algorithm: is_introsort
  end

make_with_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
    -- Create sorter with specified algorithm.
  require
    algorithm_exists: a_algorithm /= Void
  ensure
    algorithm_set: algorithm = a_algorithm
  end
```

### Queries

```eiffel
algorithm: SIMPLE_SORT_ALGORITHM [G]
    -- Current sorting algorithm.

is_introsort: BOOLEAN
    -- Is current algorithm introsort?

is_stable: BOOLEAN
    -- Does current algorithm preserve equal-element order?

is_sorted (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
    -- Is `a_container` sorted by `a_key` in ascending order?
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    empty_is_sorted: a_container.is_empty implies Result
  end

is_sorted_descending (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
    -- Is `a_container` sorted by `a_key` in descending order?
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    empty_is_sorted: a_container.is_empty implies Result
  end
```

### Commands

```eiffel
sort_by (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE])
    -- Sort `a_container` by `a_key` in ascending order.
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    sorted: is_sorted (a_container, a_key)
    count_unchanged: a_container.count = old a_container.count
  end

sort_by_descending (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE])
    -- Sort `a_container` by `a_key` in descending order.
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    sorted: is_sorted_descending (a_container, a_key)
    count_unchanged: a_container.count = old a_container.count
  end

sort_by_stable (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE])
    -- Stable sort `a_container` by `a_key` (preserves equal-element order).
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    sorted: is_sorted (a_container, a_key)
    count_unchanged: a_container.count = old a_container.count
  end

sort_by_cached_key (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE])
    -- Sort with key values cached (for expensive key functions).
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  ensure
    sorted: is_sorted (a_container, a_key)
    count_unchanged: a_container.count = old a_container.count
  end

partial_sort (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE]; a_count: INTEGER)
    -- Sort first `a_count` elements of `a_container`.
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
    valid_count: a_count >= 0 and a_count <= a_container.count
  ensure
    first_n_sorted: -- first a_count elements are the smallest, sorted
    count_unchanged: a_container.count = old a_container.count
  end

set_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
    -- Set the sorting algorithm.
  require
    algorithm_exists: a_algorithm /= Void
  ensure
    algorithm_set: algorithm = a_algorithm
  end
```

### Algorithm Constants

```eiffel
introsort: SIMPLE_INTROSORT [G]
    -- Introsort algorithm (hybrid quick/heap/insertion).
  once
    create Result
  end

merge_sort: SIMPLE_MERGE_SORT [G]
    -- Merge sort algorithm (stable, O(n log n), extra memory).
  once
    create Result
  end

heap_sort: SIMPLE_HEAP_SORT [G]
    -- Heap sort algorithm (in-place, O(n log n)).
  once
    create Result
  end

insertion_sort: SIMPLE_INSERTION_SORT [G]
    -- Insertion sort algorithm (stable, O(n²), good for small data).
  once
    create Result
  end
```

### Invariant

```eiffel
invariant
  algorithm_exists: algorithm /= Void
```

---

## SIMPLE_SORT_ALGORITHM [G]

### Identity
- **Name**: SIMPLE_SORT_ALGORITHM [G]
- **Role**: ENGINE (deferred)
- **Responsibility**: Define algorithm interface for sorting

### Genericity
```eiffel
deferred class SIMPLE_SORT_ALGORITHM [G]
```

### Queries

```eiffel
name: STRING
    -- Algorithm name for display.
  deferred
  end

is_stable: BOOLEAN
    -- Does this algorithm preserve order of equal elements?
  deferred
  end

time_complexity: STRING
    -- Big-O notation for time complexity.
  deferred
  end

space_complexity: STRING
    -- Big-O notation for space complexity.
  deferred
  end
```

### Commands

```eiffel
sort (a_container: INDEXABLE [G, INTEGER]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
    -- Sort `a_container` by `a_key`.
  require
    container_exists: a_container /= Void
    key_function_exists: a_key /= Void
  deferred
  ensure
    sorted: -- container is sorted
    count_unchanged: a_container.count = old a_container.count
  end
```

---

## SIMPLE_INTROSORT [G]

### Identity
- **Name**: SIMPLE_INTROSORT [G]
- **Role**: ENGINE
- **Responsibility**: Hybrid sorting with guaranteed O(n log n)

### Properties
- **Stable**: No
- **Time**: O(n log n) worst case
- **Space**: O(log n) for recursion stack

### Algorithm
1. Start with quicksort
2. If recursion depth exceeds 2 log n, switch to heapsort
3. For partitions < 16 elements, use insertion sort

---

## SIMPLE_MERGE_SORT [G]

### Identity
- **Name**: SIMPLE_MERGE_SORT [G]
- **Role**: ENGINE
- **Responsibility**: Stable sorting with guaranteed O(n log n)

### Properties
- **Stable**: Yes
- **Time**: O(n log n) always
- **Space**: O(n) for temporary array

---

## SIMPLE_HEAP_SORT [G]

### Identity
- **Name**: SIMPLE_HEAP_SORT [G]
- **Role**: ENGINE
- **Responsibility**: In-place sorting with guaranteed O(n log n)

### Properties
- **Stable**: No
- **Time**: O(n log n) always
- **Space**: O(1)

---

## SIMPLE_INSERTION_SORT [G]

### Identity
- **Name**: SIMPLE_INSERTION_SORT [G]
- **Role**: ENGINE
- **Responsibility**: Simple sorting for small or nearly-sorted data

### Properties
- **Stable**: Yes
- **Time**: O(n²) worst, O(n) best (already sorted)
- **Space**: O(1)

---

# 4. Contracts Summary

## Invariants

### SIMPLE_SORTER
```eiffel
invariant
  algorithm_exists: algorithm /= Void
```

## Key Preconditions

| Feature | Precondition |
|---------|--------------|
| sort_by | container_exists, key_function_exists |
| partial_sort | valid_count: count >= 0 and count <= container.count |
| set_algorithm | algorithm_exists |

## Key Postconditions

| Feature | Postcondition |
|---------|---------------|
| sort_by | sorted: is_sorted (a_container, a_key) |
| sort_by | count_unchanged: a_container.count = old a_container.count |
| sort_by_stable | sorted + preserves equal-element relative order |

---

# 5. Design Rationale

## Decision: Agent-Based Comparison (No Comparator Classes)

**Alternatives:**
- ISE/GOBO style: PART_COMPARATOR class per type
- Require COMPARABLE constraint on G

**Rationale:**
- Eliminates boilerplate (no need to create comparator classes)
- More flexible (can sort by any derived value)
- Matches modern patterns (C++ lambdas, Rust closures, Java 8+)

**Trade-offs:**
- Cannot implement asymmetry postcondition easily (catcall issues)
- Slight performance overhead from agent calls

## Decision: Default to Introsort

**Alternatives:**
- Quicksort (can degrade to O(n²))
- Mergesort (stable but uses O(n) memory)

**Rationale:**
- Guaranteed O(n log n) worst case
- Good cache performance from quicksort
- Falls back gracefully when needed

## Decision: Facade Pattern

**Rationale:**
- Single entry point simplifies API
- Hides algorithm complexity
- Follows Simple Eiffel ecosystem patterns

## OOSC2 Principles Applied

### Single Responsibility
- SIMPLE_SORTER: orchestrate sorting operations
- Algorithm classes: implement specific sorting strategies
- No class does both

### Open/Closed
- New algorithms can be added without modifying SIMPLE_SORTER
- Algorithm interface is stable

### Genericity
- SIMPLE_SORTER [G] works with any element type
- Key function extracts COMPARABLE from element

---

# 6. Implementation Phases

## Phase 1: Foundation
- [ ] Project skeleton
- [ ] SIMPLE_SORTER facade (basic)
- [ ] SIMPLE_INSERTION_SORT
- [ ] Basic tests (10+)

## Phase 2: Core Algorithms
- [ ] SIMPLE_INTROSORT (default)
- [ ] SIMPLE_MERGE_SORT
- [ ] SIMPLE_HEAP_SORT
- [ ] Comprehensive tests (30+)
- [ ] Performance benchmarks

## Phase 3: Extended Features
- [ ] sort_by_cached_key
- [ ] partial_sort
- [ ] Hardening (X01-X10)
- [ ] Documentation
- [ ] GitHub release

---

# 7. Specification Statistics

| Metric | Value |
|--------|-------|
| Classes specified | 6 |
| Features specified | ~25 |
| Contracts defined | ~15 |
| Requirements traced | 100% |

---

*Specification ready for implementation review*
*Next: Create project skeleton and implement Phase 1*
