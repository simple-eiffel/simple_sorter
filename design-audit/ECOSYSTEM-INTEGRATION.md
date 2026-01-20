# simple_sorter Ecosystem Integration Plan

## Date: 2026-01-20

---

## Executive Summary

Analysis of 101 simple_* libraries found **5 libraries** currently implementing or using sorting operations. These are candidates for simple_sorter adoption.

---

## Candidate Libraries

### Priority 1: HIGH

#### simple_math
- **File**: `/d/prod/simple_math/src/simple_statistics.e`
- **Current**: Manual insertion sort (lines 407-430)
- **Use Case**: Statistical median, percentile, quartile calculations
- **Benefit**: O(n²) → O(n log n) for large datasets
- **Integration**: Replace `sorted_data` implementation with simple_sorter

#### simple_sql
- **Files**:
  - `simple_sql_vector_store.e` (K-NN search, lines 430-450)
  - `simple_sql_similarity.e` (similarity ranking, lines 275-282)
  - `simple_sql_migration_runner.e` (version ordering, lines 101-112)
- **Current**: ISE QUICK_SORTER with AGENT_PART_COMPARATOR
- **Benefit**: Algorithm flexibility, merge_sort for stable ordering
- **Integration**: Replace ISE QUICK_SORTER with SIMPLE_SORTER

### Priority 2: MEDIUM

#### simple_container
- **File**: `/d/prod/simple_container/src/simple_sortable_list_extensions.e`
- **Current**: Manual insertion sort (lines 67-99)
- **Features**: sorted_by, sorted_by_descending
- **Benefit**: Better algorithm selection, full DBC
- **Integration**: Delegate to simple_sorter.introsort

#### simple_vision
- **File**: `/d/prod/simple_vision/src/widgets/sv_data_grid.e`
- **Current**: Sort infrastructure exists but no implementation
- **Benefit**: Full sorting implementation ready to use
- **Integration**: Implement column sorting with simple_sorter

### Priority 3: LOW

#### simple_pkg
- **File**: `/d/prod/simple_pkg/src/pkg_resolver.e`
- **Current**: DFS-based topological sort
- **Note**: Different problem domain (DAG ordering, not general sorting)
- **Status**: Leave as-is (topological sort is specialized)

---

## Integration Pattern

### Before (ISE QUICK_SORTER)

```eiffel
local
    l_comparator: AGENT_PART_COMPARATOR [TUPLE [score: REAL; item: G]]
    l_sorter: QUICK_SORTER [TUPLE [score: REAL; item: G]]
do
    create l_comparator.make (agent score_descending)
    create l_sorter.make (l_comparator)
    l_sorter.sort (results)
end
```

### After (SIMPLE_SORTER)

```eiffel
local
    l_sorter: SIMPLE_SORTER [TUPLE [score: REAL; item: G]]
do
    create l_sorter.make
    l_sorter.sort_by_descending (results, agent {TUPLE [score: REAL; item: G]}.score)
end
```

**Benefits:**
- Fewer local variables (2 → 1)
- No comparator class needed
- Agent-based comparison inline
- Algorithm selection available

---

## Integration Summary

| Library | Status | Benefit | Effort |
|---------|--------|---------|--------|
| simple_math | To Do | Performance boost | Low |
| simple_sql | To Do | Algorithm flexibility | Medium |
| simple_container | To Do | Better algorithms | Low |
| simple_vision | To Do | Full implementation | Low |
| simple_pkg | Skip | N/A (topological sort) | - |

---

## Recommended Next Steps

1. **simple_math**: Replace insertion sort in `sorted_data`
2. **simple_sql**: Replace QUICK_SORTER usages
3. **simple_container**: Delegate to simple_sorter
4. **simple_vision**: Implement data grid sorting

---

## ECF Dependencies

Libraries adopting simple_sorter will need to add:

```xml
<library name="simple_sorter" location="$SIMPLE_LIBS/simple_sorter/simple_sorter.ecf"/>
```

---

## Conclusion

simple_sorter provides a standardized, well-tested sorting solution for the Simple Eiffel ecosystem. Adoption across candidate libraries will:

1. **Unify** sorting API across ecosystem
2. **Improve** performance (O(n log n) algorithms)
3. **Enable** algorithm selection per use case
4. **Simplify** code (no comparator classes)
5. **Guarantee** correctness via DBC contracts
