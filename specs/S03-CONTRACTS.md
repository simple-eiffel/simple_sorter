# S03: CONTRACTS
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Design by Contract Summary

### SIMPLE_SORTER Contracts

```eiffel
sort_by (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
    ensure
        sorted: is_sorted (a_list, a_key)
        count_unchanged: a_list.count = old a_list.count

sort_by_descending (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
    ensure
        sorted: is_sorted_descending (a_list, a_key)
        count_unchanged: a_list.count = old a_list.count

is_sorted_by_keys (a_list: LIST [G]; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN]): BOOLEAN
    require
        keys_not_empty: not a_keys.is_empty
        same_count: a_keys.count = a_descending.count

sort_by_keys (a_list: LIST [G]; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN])
    require
        keys_not_empty: not a_keys.is_empty
        same_count: a_keys.count = a_descending.count
    ensure
        count_unchanged: a_list.count = old a_list.count
        sorted_by_all_keys: is_sorted_by_keys (a_list, a_keys, a_descending)
        empty_unchanged: old a_list.is_empty implies a_list.is_empty

compare_by_keys (a_first, a_second: G; a_keys: ARRAY [FUNCTION]; a_descending: ARRAY [BOOLEAN]): INTEGER
    require
        keys_not_empty: not a_keys.is_empty
        same_count: a_keys.count = a_descending.count
    ensure
        zero_means_equal_on_all_keys: Result = 0 implies
            across a_keys.lower |..| a_keys.upper as k all
                a_keys [k].item ([a_first]).three_way_comparison (a_keys [k].item ([a_second])) = 0
            end
```

### SIMPLE_SORT_ALGORITHM Contracts

```eiffel
sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
    deferred
    ensure
        count_unchanged: a_array.count = old a_array.count
        result_sorted: is_sorted (a_array, a_key, a_descending)
        result_permutation: is_permutation (a_array, old a_array.twin)
        model_sorted: is_sequence_sorted (array_to_sequence (a_array), a_key, a_descending)
        model_permutation: array_to_bag (a_array) |=| old array_to_bag (a_array.twin)
```

### SIMPLE_INTROSORT Contracts

```eiffel
partition (a_array: ARRAY [G]; a_left, a_right: INTEGER; ...): INTEGER
    require
        left_valid: a_array.valid_index (a_left)
        right_valid: a_array.valid_index (a_right)
        range_valid: a_left < a_right
    ensure
        result_in_range: Result >= a_left and Result <= a_right

log2_floor (a_n: INTEGER): INTEGER
    require
        n_positive: a_n > 0
    ensure
        result_non_negative: Result >= 0

swap (a_array: ARRAY [G]; a_i, a_j: INTEGER)
    require
        i_valid: a_array.valid_index (a_i)
        j_valid: a_array.valid_index (a_j)
    ensure
        swapped_i: a_array [a_i] = old a_array [a_j]
        swapped_j: a_array [a_j] = old a_array [a_i]
```

## MML Model Queries

```eiffel
list_to_sequence (a_list: LIST [G]): MML_SEQUENCE [G]
    ensure
        same_count: Result.count = a_list.count

list_to_bag (a_list: LIST [G]): MML_BAG [G]
    ensure
        same_count: Result.count = a_list.count

is_sequence_sorted (a_seq: MML_SEQUENCE [G]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
    ensure
        empty_sorted: a_seq.is_empty implies Result
        singleton_sorted: a_seq.count = 1 implies Result
```
