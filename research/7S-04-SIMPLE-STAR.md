# 7S-04: SIMPLE-STAR ECOSYSTEM
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Ecosystem Dependencies

### Uses (Dependencies)
- **EiffelBase**: ARRAYED_LIST, ARRAY, COMPARABLE
- **MML (Mathematical Model Library)**: MML_SEQUENCE, MML_BAG

### Used By (Dependents)
- Any library needing flexible sorting
- Potentially: simple_table, simple_query

## Integration Points

### Basic Sort by Key
```eiffel
local
    sorter: SIMPLE_SORTER [PERSON]
    people: LIST [PERSON]
do
    create sorter.make
    sorter.sort_by (people, agent {PERSON}.age)
end
```

### Descending Sort
```eiffel
sorter.sort_by_descending (people, agent {PERSON}.salary)
```

### Multi-Key Sort
```eiffel
sorter.sort_by_keys (people,
    <<agent {PERSON}.department, agent {PERSON}.name>>,
    <<False, False>>)  -- Both ascending
```

### Stable Sort
```eiffel
sorter.sort_by_stable (people, agent {PERSON}.department)
```

### Algorithm Selection
```eiffel
create sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [PERSON]})
-- Or switch at runtime
sorter.set_algorithm (sorter.heap_sort)
```

## Ecosystem Role

simple_sorter is a **foundation utility** providing generic sorting that any other library can use.
