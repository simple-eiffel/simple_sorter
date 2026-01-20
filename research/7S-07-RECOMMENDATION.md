# 7S-07: FINAL RECOMMENDATION - simple_sorter

## Date: 2026-01-20

---

# Executive Summary

**Project:** simple_sorter

**Purpose:** Create a modern, ergonomic sorting library for the Simple Eiffel ecosystem that provides agent-based comparison, multiple algorithms, and stable sorting options with full Design by Contract.

**Recommendation:** **PROCEED**

## Key Findings

1. **Gap exists:** ISE/GOBO have algorithms but poor ergonomics; simple_container has good ergonomics but only one algorithm
2. **Pattern clear:** Agent-based comparison (like simple_container's sorted_by) is the modern pattern to follow
3. **Low risk:** Sorting algorithms are well-understood; implementation is straightforward

## Key Risks

| Risk | Mitigation |
|------|------------|
| Performance regression vs ISE | Benchmark against ISE sorters; use introsort hybrid |
| Agent call overhead | Cache keys for expensive computations (sort_by_cached_key) |

## Go/No-Go Score

| Factor | Weight | Score | Weighted |
|--------|--------|-------|----------|
| Problem value | 3 | 4 | 12 |
| Solution viability | 3 | 5 | 15 |
| Competitive advantage | 2 | 4 | 8 |
| Risk level | 3 | 4 | 12 |
| Resource availability | 2 | 5 | 10 |
| Strategic fit | 2 | 5 | 10 |
| **Total** | 15 | | **67/75** |

**Score Interpretation:** 67/75 = **Strong GO**

---

# Research Synthesis

## SCOPE (from 7S-01)

| Aspect | Summary |
|--------|---------|
| Problem | Eiffel developers need simpler sorting API with agent comparison |
| Users | Simple Eiffel ecosystem developers |
| Success | One-liner sorting with custom comparison, multiple algorithms |

## LANDSCAPE (from 7S-02)

| Aspect | Summary |
|--------|---------|
| Alternatives found | 4 (ISE, GOBO, Eiffel-Loop, simple_container) |
| Best alternative | simple_container sorted_by pattern (API only) |
| Our differentiation | Combined: best API + multiple algorithms + DBC |

## REQUIREMENTS (from research)

### Functional Requirements

| Priority | Requirement |
|----------|-------------|
| MUST | Sort arrays and lists in place |
| MUST | Agent-based comparison (sort_by_key pattern) |
| MUST | Ascending and descending order |
| MUST | Multiple algorithms (at least quick, insertion, merge) |
| SHOULD | Stable sorting option |
| SHOULD | Partial sorting (first N elements) |
| SHOULD | Key caching for expensive key functions |
| COULD | Topological sorting with cleaner API |
| COULD | Parallel sorting (SCOOP) |

### Non-Functional Requirements

| NFR | Target |
|-----|--------|
| Performance | Within 20% of ISE sorters |
| Void safety | Full (void_safety="all") |
| SCOOP | Compatible |
| DBC | 100% contract coverage |

## DECISIONS (from research)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Build/Buy/Adapt | Build (with pattern adoption) | Best API pattern exists, need new implementation |
| Architecture | Facade + Strategy | SIMPLE_SORTER facade, algorithm strategies |
| Algorithm comparison | Agent-based only | Eliminates comparator classes |
| Default algorithm | Introsort hybrid | Best overall performance |

## INNOVATIONS

| Innovation | Value |
|------------|-------|
| Agent-only comparison | No comparator classes needed |
| sort_by + sort_by_descending | Clean symmetry |
| sort_by_cached_key | Expensive key optimization |
| Hybrid algorithm default | Guaranteed O(n log n) |
| Full DBC | Self-documenting, verifiable |

## RISKS

| Risk | Severity | Likelihood | Mitigation |
|------|----------|------------|------------|
| Performance regression | MEDIUM | LOW | Benchmark continuously |
| Catcall issues with agents | LOW | MEDIUM | Avoid agent-based postconditions |
| Complexity creep | LOW | MEDIUM | Clear phase boundaries |

---

# Recommendation Details

## What We Should Do

Create **simple_sorter** library with:

1. **SIMPLE_SORTER [G]** facade class
2. **Agent-based comparison** (sort_by pattern from simple_container)
3. **Multiple algorithms** (introsort default, merge, insertion, heap)
4. **Stable sorting** option
5. **Full Design by Contract**

## Why

1. Fills gap in Simple Eiffel ecosystem
2. Modern API pattern already proven in simple_container
3. Low implementation risk (well-understood algorithms)
4. High value for ecosystem completeness

## Conditions

None - strong GO

---

# Implementation Roadmap

```
Phase 1: Foundation     Phase 2: Core        Phase 3: Extended
├──────────────────────┼───────────────────┼──────────────────┤
|████████████████████||█████████████████||████████████████|
├──────────────────────┼───────────────────┼──────────────────┤
Milestone: Basic API   Milestone: Tests    Milestone: v1.0
```

## Phase 1: Foundation

**Deliverables:**
- Project skeleton (ECF, folder structure)
- SIMPLE_SORTER facade class
- sort_by and sort_by_descending with insertion sort
- Basic tests

**Milestone:** Can sort ARRAYED_LIST with agent comparison

## Phase 2: Core Algorithms

**Deliverables:**
- Quicksort implementation
- Merge sort implementation
- Introsort hybrid
- Algorithm selection API
- Comprehensive tests (30+)

**Milestone:** All algorithms pass tests, performance benchmarked

## Phase 3: Extended Features

**Deliverables:**
- Stable sort option
- Partial sorting
- Key caching
- Topological sort (clean API)
- Hardening (X01-X10)
- GitHub release

**Milestone:** v1.0.0 released on GitHub

---

# Next Steps

| # | Action | Output |
|---|--------|--------|
| 1 | Create project skeleton | simple_sorter.ecf, folders |
| 2 | Implement SIMPLE_SORTER facade | Basic API working |
| 3 | Port insertion sort from simple_container | First algorithm |
| 4 | Add quicksort | Fast algorithm |
| 5 | Implement introsort | Default hybrid |
| 6 | Test suite | 30+ tests |
| 7 | Hardening | X01-X10 complete |
| 8 | GitHub release | v1.0.0 |

---

# API Design Preview

```eiffel
-- Simple usage
create sorter
sorter.sort (my_list)  -- natural order

-- Sort by key (most common)
sorter.sort_by (my_list, agent {PERSON}.age)

-- Descending
sorter.sort_by_descending (my_list, agent {PERSON}.name)

-- Algorithm choice
sorter.set_algorithm (sorter.merge_sort)
sorter.sort_by (my_list, agent {PERSON}.salary)

-- Stable sort
sorter.sort_by_stable (my_list, agent {PERSON}.department)

-- With caching for expensive keys
sorter.sort_by_cached_key (my_list, agent compute_expensive_score)
```

---

# Class Structure Preview

```
┌─────────────────────────────────────────────────────────────────┐
│                     SIMPLE_SORTER [G]                           │
│  Facade: provides all sorting operations                        │
├─────────────────────────────────────────────────────────────────┤
│  + sort (container)                                             │
│  + sort_by (container, key_function)                            │
│  + sort_by_descending (container, key_function)                 │
│  + sort_by_stable (container, key_function)                     │
│  + sort_by_cached_key (container, key_function)                 │
│  + partial_sort (container, n)                                  │
│  + set_algorithm (algorithm)                                    │
│  + is_sorted (container): BOOLEAN                               │
│                                                                 │
│  Algorithms: quick_sort, merge_sort, heap_sort, insertion_sort  │
└─────────────────────────────────────────────────────────────────┘
              │
              │ uses internally
              ▼
┌─────────────────────────────────────────────────────────────────┐
│              SIMPLE_SORT_ALGORITHM [G]                          │
│  Deferred class for algorithm implementations                   │
├─────────────────────────────────────────────────────────────────┤
│  + sort_with_key (container, key_function, descending)          │
│  + is_stable: BOOLEAN                                           │
└─────────────────────────────────────────────────────────────────┘
              △
              │ inherits
    ┌─────────┼─────────┬─────────┬─────────┐
    │         │         │         │         │
    ▼         ▼         ▼         ▼         ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│INTRO- │ │MERGE  │ │HEAP   │ │INSER- │ │TOPO-  │
│SORTER │ │SORTER │ │SORTER │ │TION   │ │LOGICAL│
└───────┘ └───────┘ └───────┘ └───────┘ └───────┘
```

---

# Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| API simplicity | One-liner sorts | Code examples |
| Algorithm count | 5+ | Class count |
| Test count | 30+ | Test runner |
| Performance | Within 20% of ISE | Benchmark |
| Contract coverage | 100% | Audit |

---

# Appendix: Research Documents

| Document | Content |
|----------|---------|
| 7S-01-SCOPE.md | Problem definition, users, success criteria |
| 7S-02-LANDSCAPE.md | Existing solutions analysis |
| 7S-07-RECOMMENDATION.md | Final recommendation (this document) |
| specs/SPEC-SUMMARY.md | ISE sorting infrastructure specification |
| specs/S01-INVENTORY-PROJECT.md | ISE class inventory |
| specs/S02-DOMAIN-MODEL.md | Sorting domain model |

---

*Research completed: 2026-01-20*
*Ready for: Implementation (or Spec-from-Research workflow if detailed specs needed)*

**RECOMMENDATION: PROCEED** with simple_sorter implementation
