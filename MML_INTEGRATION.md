# MML Integration - simple_sorter

## Overview
Applied X03 Contract Assault with simple_mml on 2025-01-21.

## MML Classes Used
- `MML_SEQUENCE [G]` - Models ordered sequence after sorting
- `MML_BAG [G]` - Verifies permutation property (same multiset)

## Model Queries Added
- `array_to_sequence: MML_SEQUENCE [G]` - Array as sequence
- `array_to_bag: MML_BAG [G]` - Array as bag
- `list_to_sequence: MML_SEQUENCE [G]` - List as sequence
- `list_to_bag: MML_BAG [G]` - List as bag
- `is_sequence_sorted` - Checks MML sequence ordering
- `is_permutation` - Verifies bag equality

## Model-Based Postconditions
| Feature | Postcondition | Purpose |
|---------|---------------|---------|
| `sort` | `model_sorted` | Result is ordered |
| `sort` | `model_permutation` | Same elements (bag equality) |
| `sort_by` | `model_sorted` | Sorted by key |
| `sort_by_stable` | `model_permutation` | Stable sort preserves order |

## Invariants Added
- Simplified invariants (removed redundant void checks)

## Bugs Found
None

## Test Results
- Compilation: SUCCESS
- Tests: 30/30 PASS
