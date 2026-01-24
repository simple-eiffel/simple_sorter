# S06: BOUNDARIES
**Library**: simple_sorter
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## System Boundaries

```
┌─────────────────────────────────────────────────────────────┐
│                      simple_sorter                           │
│  ┌───────────────────────────────────────────────────────┐ │
│  │                  SIMPLE_SORTER [G]                     │ │
│  │  (facade: sort_by, sort_by_keys, is_sorted, etc.)     │ │
│  └───────────────────────────────────────────────────────┘ │
│                          │                                  │
│                          ▼                                  │
│  ┌───────────────────────────────────────────────────────┐ │
│  │            SIMPLE_SORT_ALGORITHM [G]                   │ │
│  │  (deferred: name, is_stable, sort)                    │ │
│  └───────────────────────────────────────────────────────┘ │
│         ┌────────┬────────┬────────┬────────┐              │
│         │        │        │        │                       │
│         ▼        ▼        ▼        ▼                       │
│  ┌──────────┐┌──────────┐┌──────────┐┌──────────┐         │
│  │INTROSORT ││MERGE_SORT││HEAP_SORT ││INSERTION │         │
│  │(default) ││(stable)  ││(in-place)││(small)   │         │
│  └──────────┘└──────────┘└──────────┘└──────────┘         │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              MML Model Functions                       │ │
│  │  (list_to_sequence, list_to_bag, is_sequence_sorted)  │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │    EiffelBase/MML     │
              │ LIST, ARRAY, FUNCTION │
              │ MML_SEQUENCE, MML_BAG │
              └───────────────────────┘
```

## Data Flow

```
Input: LIST [G]          Key Extractor: FUNCTION [G, COMPARABLE]
       │                              │
       ▼                              │
create_array_from_list ◄──────────────┘
       │
       ▼
SIMPLE_SORT_ALGORITHM.sort (array, key, descending)
       │
       ▼
copy_array_to_list
       │
       ▼
Output: LIST [G] (sorted in place)
```

## Algorithm Selection Flow

```
User calls sort_by
       │
       ▼
  list.count > 1?  ──No──▶ Return (trivially sorted)
       │
      Yes
       │
       ▼
  create_array_from_list
       │
       ▼
  current algorithm.sort
       │
       ▼
  ┌─────────────────────────────────────────┐
  │             INTROSORT                    │
  │  size <= 16?  ──Yes──▶ insertion_sort   │
  │       │                                  │
  │      No                                  │
  │       │                                  │
  │  depth == 0?  ──Yes──▶ heap_sort        │
  │       │                                  │
  │      No                                  │
  │       │                                  │
  │  partition + recursive quicksort         │
  └─────────────────────────────────────────┘
       │
       ▼
  copy_array_to_list
       │
       ▼
  verify postconditions (is_sorted, count_unchanged)
```
