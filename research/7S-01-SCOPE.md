# 7S-01: SCOPE DEFINITION - simple_sorter

## Date: 2026-01-20

---

## Problem Statement

### In One Sentence
Eiffel developers need a simpler, more ergonomic sorting API that follows Simple Eiffel ecosystem patterns while providing modern sorting algorithms and fluent interfaces.

### In Detail

| Aspect | Description |
|--------|-------------|
| **What's wrong today** | ISE's base_extension sorters require verbose setup: create comparator, create sorter, call sort. No facade class, no agent-based comparison, no fluent API. |
| **Who experiences this** | Eiffel developers who need to sort collections frequently |
| **How often** | Sorting is a fundamental operation used in most applications |
| **Impact of not solving** | Developers continue with verbose boilerplate or implement ad-hoc solutions |

### Problem Validation

| Question | Answer |
|----------|--------|
| Is this a real problem? | YES - simple_container already added sorted_by as a workaround (simple_sortable_list_extensions.e) |
| Is it worth solving? | YES - sorting is foundational; good API improves all code that uses it |
| Has it been solved before? | PARTIALLY - ISE has algorithms but poor UX; Eiffel-Loop has some utilities |

---

## Target Users

### Primary Users

| Attribute | Description |
|-----------|-------------|
| User type | Simple Eiffel ecosystem developers |
| Needs | Sort collections with minimal code, custom comparisons, multiple algorithms |
| Current solution | ISE base_extension sorters with verbose setup, or ad-hoc implementations |
| Pain level | MEDIUM |

### Secondary Users

| Attribute | Description |
|-----------|-------------|
| User type | General Eiffel developers seeking modern collection utilities |
| Needs | Drop-in replacement for ISE sorters with better ergonomics |

### Non-Users (Explicitly)

| Not For | Reason |
|---------|--------|
| External sorting (disk-based) | Out of scope - different problem domain |
| Real-time systems needing guaranteed worst-case | Some algorithms have O(n²) worst case |
| Non-Eiffel developers | Eiffel-specific library |

---

## Success Criteria

### MVP (Minimum Viable Product)

| Criterion | Measure |
|-----------|---------|
| Basic sorting works | Can sort ARRAYED_LIST and ARRAY with one-liner |
| Agent-based comparison | Sort by any function without creating comparator classes |
| Multiple algorithms | At least quicksort and insertion sort available |
| Tests pass | 30+ tests covering all operations |

### Full Success

| Criterion | Measure |
|-----------|---------|
| Facade class | SIMPLE_SORTER provides all common operations |
| Algorithm selection | 5+ algorithms (quick, merge, heap, shell, insertion) |
| Stability option | Stable vs unstable sort choice |
| Performance | Competitive with ISE sorters |
| Full DBC | Contracts on all features |

### Stretch Goals

| Criterion | Measure |
|-----------|---------|
| Parallel sorting | SCOOP-based parallel quicksort |
| External sorting | Sort larger-than-memory datasets |
| Topological sort | Cleaner API than ISE's |

### Anti-Success (Failure Criteria)

| Failure | Description |
|---------|-------------|
| Slower than ISE | Must not regress performance significantly |
| More verbose than ISE | Must be simpler, not more complex |
| Void-unsafe | Must be fully void-safe |
| SCOOP-incompatible | Must work in SCOOP environments |

---

## Scope Boundaries

### In Scope (MUST)

| Capability | Description |
|------------|-------------|
| Sort arrays | ARRAY [G] sorting |
| Sort lists | ARRAYED_LIST [G], LIST [G] sorting |
| Ascending/descending | Both directions |
| Agent-based comparison | Sort using FUNCTION [G, COMPARABLE] |
| Multiple algorithms | Quick sort, insertion sort, merge sort |
| Stable sorting | Preserve equal element order |

### Extended Scope (SHOULD)

| Capability | Description |
|------------|-------------|
| Partial sorting | Sort only first N elements |
| Heap sort | Priority-queue based sorting |
| Shell sort | Gap-based insertion sort |
| Topological sort | Cleaner DAG sorting API |
| Radix sort | For integer/string keys |

### Out of Scope

| Excluded | Reason |
|----------|--------|
| External sorting | Different problem domain (disk I/O) |
| GPU sorting | Not relevant for Eiffel ecosystem |
| Network-distributed sort | Too specialized |
| Sorting of trees/graphs | Focus on linear structures |

### Deferred to Future

| Item | Reason |
|------|--------|
| Parallel sorting | SCOOP complexity; v2.0 feature |
| Adaptive sorting | Timsort complexity; v2.0 feature |
| Custom memory allocators | Optimization for later |

---

## Constraints

### Technical Constraints

| Constraint | Value |
|------------|-------|
| Platform | EiffelStudio 25.02+ |
| Dependencies | Only ISE base library |
| Integration | Must work with existing simple_* libraries |
| Void safety | void_safety="all" required |
| Concurrency | SCOOP-compatible |

### Design Constraints

| Constraint | Description |
|------------|-------------|
| Must follow | Simple Eiffel patterns (facade, DBC, inline C only if needed) |
| Must avoid | Separate .c files, thread concurrency, external dependencies |
| Compatibility | Must coexist with ISE base_extension sorters |

---

## High-Level Use Cases

### UC-1: Sort a List by Natural Order

**Actor:** Developer with a list of COMPARABLE elements
**Goal:** Sort the list ascending
**Typical scenario:**
```eiffel
create sorter
sorter.sort (my_list)  -- sorted in place
```

### UC-2: Sort by Custom Key

**Actor:** Developer with objects needing custom ordering
**Goal:** Sort by a specific attribute
**Typical scenario:**
```eiffel
create sorter
sorter.sort_by (my_list, agent {PERSON}.age)  -- sort by age
```

### UC-3: Sort Descending

**Actor:** Developer needing reverse order
**Goal:** Sort from highest to lowest
**Typical scenario:**
```eiffel
create sorter
sorter.sort_descending (my_list)
```

### UC-4: Choose Algorithm

**Actor:** Developer with performance requirements
**Goal:** Use specific algorithm
**Typical scenario:**
```eiffel
create sorter.make_with_algorithm (sorter.merge_sort)
sorter.sort (my_list)  -- guaranteed O(n log n)
```

### Edge Cases to Consider

- Empty collections
- Single element
- Already sorted
- Reverse sorted
- All equal elements
- Very large collections (100K+ elements)

---

## Assumptions

| ID | Assumption | Evidence | Risk if False |
|----|------------|----------|---------------|
| A-1 | Collections support indexed access | ISE base library guarantees | Would need different approach |
| A-2 | Agent calls are reasonably fast | Used throughout Eiffel | Performance impact |
| A-3 | In-place sorting is preferred | Common pattern | Would need copy variants |
| A-4 | COMPARABLE exists for most types | Standard in Eiffel | Need more agent-based sorts |

### Assumptions to Validate

- Is merge sort worth including (extra memory)?
- Is there demand for stable sorting in Eiffel community?
- What algorithm does Eiffel-Loop use?

---

## Research Questions

### About the Problem

1. How often do Eiffel developers sort collections?
2. What are the most common pain points with ISE sorters?
3. What comparison patterns are most common (natural order vs custom)?

### About Existing Solutions

4. What algorithms does ISE provide and what's missing?
5. Does Eiffel-Loop have sorting utilities?
6. How do other languages make sorting ergonomic (C++, Rust, Java)?

### About Our Approach

7. Should we wrap ISE sorters or implement from scratch?
8. How to design agent-based comparison without catcall issues?
9. What's the best facade API design?

### About Feasibility

10. Can we achieve competitive performance with agent-based comparison?
11. Can we implement stable quicksort efficiently?
12. How to handle generic type constraints (COMPARABLE vs any)?

---

## Stakeholders

| Stakeholder | Interest |
|-------------|----------|
| Larry (project owner) | Simple Eiffel ecosystem completeness |
| Eiffel developers | Easier sorting in daily code |
| simple_container users | Integration with existing collection operations |

### Decision Makers

- Larry approves design and implementation approach

### Information Sources

- ISE base_extension source code (analyzed)
- OOSC2 (Meyer's design principles)
- Algorithm textbooks (Cormen, Sedgewick)
- Other language standard libraries (C++ STL, Rust std::sort)

---

## Summary

**simple_sorter** will provide a modern, ergonomic sorting API for the Simple Eiffel ecosystem, featuring:

1. Facade pattern with SIMPLE_SORTER class
2. Agent-based custom comparison (no comparator classes needed)
3. Multiple algorithm choices (quick, merge, heap, insertion, shell)
4. Stable and unstable sort options
5. Full Design by Contract
6. SCOOP compatibility

Next: Research existing solutions (7S-02-LANDSCAPE)
