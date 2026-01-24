# S04: FEATURE SPECIFICATIONS
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## SIMPLE_SORTER Features

### Basic Sorting
| Feature | Signature | Description |
|---------|-----------|-------------|
| sort_by | (LIST [G], FUNCTION): | Sort ascending by key |
| sort_by_descending | (LIST [G], FUNCTION): | Sort descending by key |
| sort_by_stable | (LIST [G], FUNCTION): | Stable sort (preserve equal order) |
| sort_array_by | (ARRAY [G], FUNCTION): | Sort array ascending |
| sort_array_by_descending | (ARRAY [G], FUNCTION): | Sort array descending |

### Multi-Key Sorting
| Feature | Signature | Description |
|---------|-----------|-------------|
| sort_by_then_by | (LIST, key1, key2, desc2): | Primary + secondary key |
| sort_by_comparator | (LIST, FUNCTION [G, G, INTEGER]): | Custom comparator |
| sort_by_keys | (LIST, ARRAY [FUNCTION], ARRAY [BOOLEAN]): | N-key sort |
| sort_array_by_keys | (ARRAY, keys, directions): | Array N-key sort |

### Status Queries
| Feature | Signature | Description |
|---------|-----------|-------------|
| is_sorted | (LIST, key): BOOLEAN | Check ascending order |
| is_sorted_descending | (LIST, key): BOOLEAN | Check descending order |
| is_array_sorted | (ARRAY, key): BOOLEAN | Check array order |
| is_sorted_by_keys | (LIST, keys, directions): BOOLEAN | Check multi-key order |
| is_stable | : BOOLEAN | Current algorithm stable? |
| is_introsort | : BOOLEAN | Using introsort? |

### Algorithm Access
| Feature | Signature | Description |
|---------|-----------|-------------|
| algorithm | : SIMPLE_SORT_ALGORITHM [G] | Current algorithm |
| set_algorithm | (SIMPLE_SORT_ALGORITHM [G]) | Change algorithm |
| introsort | : SIMPLE_INTROSORT [G] | Get introsort instance |
| merge_sort | : SIMPLE_MERGE_SORT [G] | Get merge sort |
| heap_sort | : SIMPLE_HEAP_SORT [G] | Get heap sort |
| insertion_sort | : SIMPLE_INSERTION_SORT [G] | Get insertion sort |

## SIMPLE_SORT_ALGORITHM Features

### Access
| Feature | Signature | Description |
|---------|-----------|-------------|
| name | : STRING | Algorithm name |
| is_stable | : BOOLEAN | Preserves equal-element order? |
| time_complexity | : STRING | Big-O time |
| space_complexity | : STRING | Big-O space |

### Operations
| Feature | Signature | Description |
|---------|-----------|-------------|
| sort | (ARRAY, key, descending) | Sort in place |
| is_sorted | (ARRAY, key, desc): BOOLEAN | Check order |
| is_permutation | (ARRAY, ARRAY): BOOLEAN | Same elements? |
