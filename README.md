# simple_sorter

[![Simple Eiffel](https://img.shields.io/badge/Simple-Eiffel-blue)](https://github.com/simple-eiffel)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tests: 30](https://img.shields.io/badge/Tests-30%20passing-brightgreen)]()

Modern, ergonomic sorting library for Eiffel collections with agent-based comparison and multiple algorithm choices.

## Features

- **Agent-based comparison** - No comparator classes needed
- **Multiple algorithms** - Introsort (default), merge sort, heap sort, insertion sort
- **Stable sorting** - Preserve order of equal elements
- **Full DBC** - Design by Contract throughout
- **SCOOP compatible** - Ready for concurrent use
- **Void-safe** - 100% void safety

## Quick Start

```eiffel
local
    sorter: SIMPLE_SORTER [PERSON]
    people: ARRAYED_LIST [PERSON]
do
    create sorter.make

    -- Sort by name (ascending)
    sorter.sort_by (people, agent {PERSON}.name)

    -- Sort by age (descending)
    sorter.sort_by_descending (people, agent {PERSON}.age)

    -- Stable sort preserves order of equal elements
    sorter.sort_by_stable (people, agent {PERSON}.department)
end
```

## Installation

Add to your ECF:

```xml
<library name="simple_sorter" location="path/to/simple_sorter.ecf"/>
```

## API Reference

### SIMPLE_SORTER [G]

The main facade class for all sorting operations.

#### Creation

```eiffel
make                                    -- Default algorithm (introsort)
make_with_algorithm (a_algorithm)       -- Specific algorithm
```

#### Sorting Commands

```eiffel
sort_by (list, key_function)            -- Sort ascending
sort_by_descending (list, key_function) -- Sort descending
sort_by_stable (list, key_function)     -- Stable sort (preserves equal order)
sort_array_by (array, key_function)     -- Sort array directly
```

#### Queries

```eiffel
is_sorted (list, key_function): BOOLEAN          -- Check if sorted
is_sorted_descending (list, key_function): BOOLEAN
is_stable: BOOLEAN                               -- Is current algorithm stable?
```

#### Algorithm Selection

```eiffel
set_algorithm (algorithm)              -- Change algorithm
introsort: SIMPLE_INTROSORT [G]        -- Hybrid (default)
merge_sort: SIMPLE_MERGE_SORT [G]      -- Stable, O(n log n)
heap_sort: SIMPLE_HEAP_SORT [G]        -- In-place, O(n log n)
insertion_sort: SIMPLE_INSERTION_SORT [G]  -- O(n^2), good for small data
```

## Algorithms

| Algorithm | Time | Space | Stable | Best For |
|-----------|------|-------|--------|----------|
| Introsort | O(n log n) | O(log n) | No | General purpose (default) |
| Merge Sort | O(n log n) | O(n) | Yes | When stability needed |
| Heap Sort | O(n log n) | O(1) | No | Memory constrained |
| Insertion Sort | O(n^2) | O(1) | Yes | Small or nearly sorted |

## Examples

### Sort by Multiple Keys

```eiffel
-- Sort by department, then by name within department
sorter.sort_by_stable (employees, agent {EMPLOYEE}.department)
sorter.sort_by_stable (employees, agent {EMPLOYEE}.name)
```

### Sort Arrays Directly

```eiffel
local
    numbers: ARRAY [INTEGER]
do
    numbers := <<5, 2, 8, 1, 9>>
    sorter.sort_array_by (numbers, agent identity_int)
    -- numbers is now <<1, 2, 5, 8, 9>>
end
```

### Choose Algorithm

```eiffel
-- Use merge sort for stable sorting
create sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [PERSON]})
sorter.sort_by (people, agent {PERSON}.salary)
```

## Requirements

- EiffelStudio 25.02 or later
- Void safety: all
- Concurrency: SCOOP

## Test Coverage

- 20 core tests
- 10 adversarial tests
- Edge cases: empty, single, duplicates, extremes
- Stress tests: up to 100,000 elements

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## See Also

- [simple_container](https://github.com/simple-eiffel/simple_container) - LINQ-style collection operations
- [Simple Eiffel Documentation](https://simple-eiffel.github.io)
