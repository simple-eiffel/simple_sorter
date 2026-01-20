<p align="center">
  <img src="docs/images/logo.png" alt="simple_sorter logo" width="200">
</p>

<h1 align="center">simple_sorter</h1>

<p align="center">
  <a href="https://simple-eiffel.github.io/simple_sorter/">Documentation</a> •
  <a href="https://github.com/simple-eiffel/simple_sorter">GitHub</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Eiffel-25.02-purple.svg" alt="Eiffel 25.02">
  <img src="https://img.shields.io/badge/DBC-Contracts-green.svg" alt="Design by Contract">
</p>

**Modern, ergonomic sorting library for Eiffel collections with agent-based comparison** — Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 6 classes
- **67 tests total**
  - 37 internal (DBC contract assertions)
  - 30 external (AutoTest unit tests)

## Overview

simple_sorter provides a modern, ergonomic sorting API for Eiffel collections. Unlike traditional approaches that require creating comparator classes, simple_sorter uses agent-based comparison for a cleaner, more expressive syntax.

The library offers multiple algorithm choices — introsort (default), merge sort, heap sort, and insertion sort — allowing you to select the best algorithm for your use case. Need stable sorting? Use merge sort. Memory constrained? Use heap sort. Small or nearly sorted data? Insertion sort is optimal.

All algorithms are thoroughly tested with both standard unit tests and adversarial test cases covering edge conditions like empty lists, duplicates, reverse-sorted data, and large datasets up to 100,000 elements.

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

## API Reference

### SIMPLE_SORTER [G]

| Feature | Description |
|---------|-------------|
| `make` | Create sorter with default algorithm (introsort) |
| `make_with_algorithm` | Create sorter with specific algorithm |
| `sort_by` | Sort list ascending by key function |
| `sort_by_descending` | Sort list descending by key function |
| `sort_by_stable` | Stable sort preserving order of equal elements |
| `sort_array_by` | Sort array directly by key function |
| `sort_array_by_descending` | Sort array descending by key function |
| `is_sorted` | Query if list is sorted ascending |
| `is_sorted_descending` | Query if list is sorted descending |
| `is_array_sorted` | Query if array is sorted ascending |
| `set_algorithm` | Change sorting algorithm |
| `is_stable` | Query if current algorithm is stable |

### SIMPLE_SORT_ALGORITHM [G]

| Feature | Description |
|---------|-------------|
| `name` | Algorithm name (e.g., "introsort") |
| `is_stable` | True if algorithm preserves order of equal elements |
| `time_complexity` | Big-O time complexity string |
| `space_complexity` | Big-O space complexity string |
| `sort` | Sort array with key function and direction |

### Algorithm Classes

| Class | Stable | Time | Space |
|-------|--------|------|-------|
| `SIMPLE_INTROSORT [G]` | No | O(n log n) | O(log n) |
| `SIMPLE_MERGE_SORT [G]` | Yes | O(n log n) | O(n) |
| `SIMPLE_HEAP_SORT [G]` | No | O(n log n) | O(1) |
| `SIMPLE_INSERTION_SORT [G]` | Yes | O(n²) | O(1) |

## Features

- ✅ Agent-based comparison (no comparator classes needed)
- ✅ Multiple algorithms (introsort, merge sort, heap sort, insertion sort)
- ✅ Stable sorting (preserve order of equal elements)
- ✅ Sort by ascending or descending
- ✅ Direct array sorting
- ✅ Sorted state queries
- ✅ Design by Contract throughout (37 contract clauses)
- ✅ Void-safe
- ✅ SCOOP-compatible

## Installation

### Using as ECF Dependency

Add to your `.ecf` file:

```xml
<library name="simple_sorter" location="$SIMPLE_LIBS/simple_sorter/simple_sorter.ecf"/>
```

### Environment Setup

Set the `SIMPLE_LIBS` environment variable:
```bash
export SIMPLE_LIBS=/path/to/simple/libraries
```

## Dependencies

None — simple_sorter only depends on EiffelBase.

## License

MIT License - see [LICENSE](LICENSE) file.

---

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.
