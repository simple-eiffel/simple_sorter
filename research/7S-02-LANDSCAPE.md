# 7S-02: LANDSCAPE ANALYSIS - simple_sorter

## Date: 2026-01-20

---

## Summary

The sorting landscape has three tiers: (1) language standard libraries with highly optimized algorithms, (2) Eiffel-specific libraries with varying levels of completeness, and (3) simple_* ecosystem which currently lacks a dedicated sorting library. Modern languages (C++, Rust, Java) emphasize lambda/closure-based comparisons and stable sorting options. Eiffel libraries (ISE, GOBO) use the Strategy pattern with explicit Comparator classes. The simple_* ecosystem should adopt the best of both: agent-based comparisons with a clean facade API.

---

## Existing Solutions Inventory

| Name | Type | Platform | Maturity | License |
|------|------|----------|----------|---------|
| ISE base_extension | LIBRARY | Eiffel | MATURE | EFL 2.0 |
| GOBO DS_SORTER | LIBRARY | Eiffel | MATURE | MIT |
| Eiffel-Loop | LIBRARY | Eiffel | MATURE | MIT |
| simple_container sorted_by | LIBRARY | Eiffel | MATURE | MIT |
| C++ std::sort | STANDARD | C++ | MATURE | N/A |
| Rust slice::sort | STANDARD | Rust | MATURE | MIT/Apache |
| Java Collections.sort | STANDARD | Java | MATURE | GPL |

---

## Solution Analysis

### 1. ISE base_extension Sorters

**Purpose:** Strategy-pattern sorting for INDEXABLE containers

**Strengths:**
+ Multiple algorithms (quick, bubble, shell)
+ Full Design by Contract
+ Topological sorting included
+ Eric Bezault authorship (high quality)

**Weaknesses:**
- Verbose API (create comparator, create sorter, call sort)
- No agent-based comparison
- No stable sorting option
- No merge sort or heap sort
- Limited documentation

**Features:**
- Core: sort, reverse_sort, subsort, sorted query
- Notable: TOPOLOGICAL_SORTER with cycle detection
- Missing: stable sort, agent comparison, parallel sort

**API Sample:**
```eiffel
create {QUICK_SORTER [STRING]} sorter.make (create {COMPARABLE_COMPARATOR [STRING]})
sorter.sort (my_list)
```

**Relevance:** 70% - Good algorithms, poor ergonomics

---

### 2. GOBO DS_SORTER Family

**Source:** [GOBO Structure Library](https://github.com/gobo-eiffel/gobo/blob/master/library/structure/doc/sort.html)

**Purpose:** Portable sorting across Eiffel compilers

**Strengths:**
+ Similar to ISE (strategy pattern)
+ DS_SORTABLE interface for containers
+ Cross-compiler portable
+ Well-documented

**Weaknesses:**
- Same verbosity as ISE
- External dependency (GOBO is large)
- Naming prefix (DS_) differs from simple_* convention

**Features:**
- Core: DS_BUBBLE_SORTER, DS_QUICK_SORTER, DS_SHELL_SORTER
- Notable: DS_TOPOLOGICAL_SORTER
- Comparators: DS_COMPARATOR, DS_COMPARABLE_COMPARATOR

**API Sample:**
```eiffel
create sorter.make (create {DS_COMPARABLE_COMPARATOR [INTEGER]})
sorter.sort (my_container)
```

**Relevance:** 60% - Similar to ISE, adds dependency

---

### 3. Eiffel-Loop Sorting

**Source:** [Eiffel-Loop GitHub](https://github.com/finnianr/eiffel-loop)

**Purpose:** Sortable map-lists for key-value sorting

**Strengths:**
+ Integrated with map-list data structures
+ Key-based sorting built-in

**Weaknesses:**
- Tightly coupled to EL_ class hierarchy
- Not a general-purpose sorter
- 4100+ class dependency

**Relevance:** 30% - Too specialized, massive dependency

---

### 4. simple_container sorted_by

**Source:** D:\prod\simple_container\src\simple_sortable_list_extensions.e (lines 24-60)

**Purpose:** Sort lists by key selector using agents

**Strengths:**
+ Agent-based comparison (no comparator classes!)
+ Fluent return value
+ Simple API
+ Already in ecosystem

**Weaknesses:**
- Only insertion sort (O(n²))
- No algorithm choice
- Not a dedicated sorter library
- Copies instead of in-place

**Features:**
- Core: sorted_by, sorted_by_descending
- Algorithm: insertion sort only

**API Sample:**
```eiffel
create ext.make (my_list)
sorted_list := ext.sorted_by (agent {PERSON}.age)
```

**Relevance:** 90% - Best API pattern, needs more algorithms

---

### 5. C++ std::sort

**Source:** [cppreference.com](https://en.cppreference.com/w/cpp/algorithm/sort.html)

**Purpose:** Generic sorting for random-access iterators

**Strengths:**
+ Introsort hybrid (quicksort + heapsort + insertion)
+ Guaranteed O(n log n) since C++11
+ Lambda comparators
+ Parallel execution (C++17)
+ stable_sort available

**Weaknesses:**
- Iterator complexity
- Not applicable to Eiffel directly

**Features:**
- Core: sort, stable_sort, partial_sort, nth_element
- C++20: std::ranges::sort for cleaner syntax
- Parallel: std::execution::par

**API Sample:**
```cpp
std::sort(vec.begin(), vec.end(), [](auto& a, auto& b) { return a.age < b.age; });
```

**Pattern to Adopt:** Lambda/agent comparison, stable sort option, hybrid algorithms

---

### 6. Rust slice::sort

**Source:** [Rust RFC 1884](https://rust-lang.github.io/rfcs/1884-unstable-sort.html)

**Purpose:** Slice sorting with stability options

**Strengths:**
+ Clear stable vs unstable distinction
+ sort_by_key for selector-based sorting
+ sort_by_cached_key for expensive keys
+ Excellent documentation

**Weaknesses:**
- Rust-specific (lifetimes, borrowing)

**Features:**
- Core: sort, sort_unstable, sort_by, sort_by_key
- Notable: sort_by_cached_key (caches key computation)

**API Sample:**
```rust
vec.sort_by_key(|p| p.age);  // Simple!
vec.sort_by_cached_key(|p| expensive_computation(p));  // Cache keys
```

**Pattern to Adopt:** sort_by_key pattern (matches simple_container's sorted_by)

---

### 7. Java Collections.sort

**Source:** [Baeldung Java Sorting](https://www.baeldung.com/java-8-sort-lambda)

**Purpose:** Collection sorting with Comparator

**Strengths:**
+ Lambda comparators (Java 8+)
+ Comparator.comparing() for field extraction
+ thenComparing() for multi-field sorts
+ nullsFirst/nullsLast handling

**Weaknesses:**
- Verbosity in pre-Java-8 code
- Boxing overhead

**Features:**
- Core: Collections.sort, List.sort
- Notable: Comparator.comparing, thenComparing, reversed

**API Sample:**
```java
list.sort(Comparator.comparing(Person::getName).thenComparing(Person::getAge));
```

**Pattern to Adopt:** Multi-key sorting (then_by)

---

## Comparison Matrix

| Feature | ISE | GOBO | Eiffel-Loop | simple_container | C++ | Rust | Java |
|---------|-----|------|-------------|------------------|-----|------|------|
| Agent/lambda comparison | ✗ | ✗ | ✗ | ✓ | ✓ | ✓ | ✓ |
| Multiple algorithms | ✓ | ✓ | ✗ | ✗ | ✓ | ✓ | ✗ |
| Stable sort | ✗ | ✗ | ✗ | ✓* | ✓ | ✓ | ✓ |
| In-place sort | ✓ | ✓ | ✗ | ✗ | ✓ | ✓ | ✓ |
| Partial sort | ✓ | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ |
| Topological sort | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Design by Contract | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ |
| Facade pattern | ✗ | ✗ | ✗ | ✗** | N/A | N/A | N/A |

*simple_container's insertion sort is naturally stable
**sorted_by is an extension, not a facade

## Scores

| Criterion | ISE | GOBO | Eiffel-Loop | simple_container |
|-----------|-----|------|-------------|------------------|
| Completeness | 4 | 4 | 2 | 2 |
| Ease of use | 2 | 2 | 2 | 5 |
| Performance | 4 | 4 | 3 | 2 |
| Documentation | 3 | 4 | 3 | 3 |
| Ecosystem fit | 3 | 2 | 2 | 5 |
| **Total** | **16** | **16** | **12** | **17** |

---

## Patterns Identified

### Pattern 1: Strategy Pattern for Algorithms

**Seen in:** ISE, GOBO
**Description:** Separate sorter class per algorithm, with common interface
**Purpose:** Algorithm substitutability
**Adopt:** YES - but simplify with facade

### Pattern 2: Comparator as Strategy

**Seen in:** ISE, GOBO, Java (pre-8)
**Description:** Separate comparator class for ordering
**Purpose:** Decouples comparison from sorting
**Adopt:** NO - use agents instead (modern pattern)

### Pattern 3: Agent/Lambda Comparison

**Seen in:** C++, Rust, Java 8+, simple_container
**Description:** Pass comparison function directly
**Purpose:** Eliminates comparator class boilerplate
**Adopt:** YES - core design principle

### Pattern 4: Stable vs Unstable

**Seen in:** C++, Rust
**Description:** Explicit choice between preserving equal element order
**Purpose:** Performance vs correctness tradeoff
**Adopt:** YES - offer both options

### Pattern 5: Sort by Key

**Seen in:** Rust sort_by_key, simple_container sorted_by
**Description:** Extract key from element, sort by key
**Purpose:** Most common sorting pattern
**Adopt:** YES - primary API

### Pattern 6: Hybrid Algorithm

**Seen in:** C++ introsort (quick + heap + insertion)
**Description:** Combine algorithms for best overall performance
**Purpose:** Guaranteed O(n log n) with good average case
**Adopt:** YES - default algorithm should be hybrid

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Comparator Class Requirement

**Seen in:** ISE, GOBO
**Problem:** Boilerplate code for every sort
**Avoid by:** Agent-based comparison

### Anti-Pattern 2: Single Algorithm Only

**Seen in:** simple_container (insertion sort only)
**Problem:** Poor performance on large datasets
**Avoid by:** Multiple algorithm options

### Anti-Pattern 3: Copy-Only Sorting

**Seen in:** simple_container sorted_by
**Problem:** Memory overhead, no in-place option
**Avoid by:** Both copy and in-place variants

---

## Build vs Buy vs Adapt

### OPTION 1: BUILD (Create from Scratch)

| Aspect | Assessment |
|--------|------------|
| Effort | MEDIUM |
| Risk | LOW |
| Benefit | Perfect fit for simple_* ecosystem |
| Drawback | Algorithm implementation work |

### OPTION 2: BUY/ADOPT (Use ISE or GOBO)

| Aspect | Assessment |
|--------|------------|
| Candidate | ISE base_extension |
| Fit | 60% - good algorithms, poor API |
| Gaps | No agent comparison, no facade |
| Effort | LOW integration, HIGH API wrapping |

### OPTION 3: ADAPT (Build on simple_container)

| Aspect | Assessment |
|--------|------------|
| Base | simple_container sorted_by pattern |
| Changes | Add algorithms, in-place sorting, facade |
| Effort | MEDIUM |
| Licensing | MIT (no issues) |

### **RECOMMENDATION: HYBRID APPROACH**

1. **Adopt:** simple_container's agent-based API pattern (sorted_by)
2. **Build:** New facade class SIMPLE_SORTER
3. **Implement:** Multiple algorithms (quick, merge, insertion, heap)
4. **Reference:** ISE/GOBO for algorithm correctness

---

## Lessons Learned

### DO

- Use agent-based comparison (modern, clean)
- Provide sort_by_key as primary API
- Offer stable and unstable options
- Default to hybrid algorithm for best performance
- Include in-place and copy variants
- Design by Contract throughout

### DON'T

- Require comparator classes (boilerplate)
- Force single algorithm choice
- Only support copying sorts
- Ignore performance on large datasets
- Skip topological sorting (useful)

### OPEN QUESTIONS

1. Should SIMPLE_SORTER inherit from SORTER or be standalone?
2. How to handle catcall issues with agent-based postconditions?
3. Is merge sort worth the extra memory cost?
4. Should we support multi-key sorting (then_by)?
5. How to integrate with simple_container without circular dependency?

---

## References

### Documentation
- [C++ std::sort](https://en.cppreference.com/w/cpp/algorithm/sort.html)
- [Rust slice sorting RFC](https://rust-lang.github.io/rfcs/1884-unstable-sort.html)
- [Java Baeldung sorting guide](https://www.baeldung.com/java-8-sort-lambda)
- [GOBO Structure Library](https://github.com/gobo-eiffel/gobo/blob/master/library/structure/doc/sort.html)

### Repositories
- [GOBO GitHub](https://github.com/gobo-eiffel/gobo)
- [Eiffel-Loop GitHub](https://github.com/finnianr/eiffel-loop)
- [cpp-sort](https://github.com/Morwenn/cpp-sort)

### Source Code Analyzed
- ISE base_extension/structures/sort/*.e (analyzed lines 1-376)
- simple_container/src/simple_sortable_list_extensions.e (lines 1-104)
