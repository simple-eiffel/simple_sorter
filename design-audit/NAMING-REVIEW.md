# simple_sorter Naming Review

## Date: 2026-01-20

---

## Class Names

| Class | Convention | Status |
|-------|------------|--------|
| SIMPLE_SORTER | SIMPLE_ prefix, noun | OK |
| SIMPLE_SORT_ALGORITHM | SIMPLE_ prefix, noun | OK |
| SIMPLE_INTROSORT | SIMPLE_ prefix, algorithm name | OK |
| SIMPLE_MERGE_SORT | SIMPLE_ prefix, algorithm name | OK |
| SIMPLE_HEAP_SORT | SIMPLE_ prefix, algorithm name | OK |
| SIMPLE_INSERTION_SORT | SIMPLE_ prefix, algorithm name | OK |

**All class names follow SIMPLE_* prefix convention.**

---

## Feature Names

### SIMPLE_SORTER

| Feature | Type | Convention | Status |
|---------|------|------------|--------|
| make | creation | verb | OK |
| make_with_algorithm | creation | verb_with_noun | OK |
| algorithm | query | noun | OK |
| is_introsort | status query | is_adjective | OK |
| is_stable | status query | is_adjective | OK |
| is_sorted | query | is_past_participle | OK |
| is_sorted_descending | query | is_past_participle_qualifier | OK |
| is_array_sorted | query | is_noun_past_participle | OK |
| sort_by | command | verb_by | OK |
| sort_by_descending | command | verb_by_qualifier | OK |
| sort_by_stable | command | verb_by_qualifier | OK |
| sort_array_by | command | verb_noun_by | OK |
| sort_array_by_descending | command | verb_noun_by_qualifier | OK |
| set_algorithm | command | set_noun | OK |
| introsort | query | noun (algorithm name) | OK |
| merge_sort | query | noun (algorithm name) | OK |
| heap_sort | query | noun (algorithm name) | OK |
| insertion_sort | query | noun (algorithm name) | OK |

### SIMPLE_SORT_ALGORITHM

| Feature | Type | Convention | Status |
|---------|------|------------|--------|
| name | query | noun | OK |
| is_stable | status query | is_adjective | OK |
| time_complexity | query | noun | OK |
| space_complexity | query | noun | OK |
| sort | command | verb | OK |

---

## Parameter Names

| Parameter | Convention | Status |
|-----------|------------|--------|
| a_algorithm | a_ prefix | OK |
| a_container | a_ prefix | OK |
| a_list | a_ prefix | OK |
| a_array | a_ prefix | OK |
| a_key | a_ prefix | OK |
| a_descending | a_ prefix | OK |
| a_left, a_right | a_ prefix | OK |
| a_size, a_root | a_ prefix | OK |

**All parameters use a_ prefix convention.**

---

## Local Variable Names

| Variable | Convention | Status |
|----------|------------|--------|
| l_sorter | l_ prefix | OK |
| l_list | l_ prefix | OK |
| l_array | l_ prefix | OK |
| l_temp | l_ prefix | OK |
| l_current | l_ prefix | OK |
| l_done | l_ prefix | OK |
| i, j, k | standard loop counters | OK |

**All local variables use l_ prefix or standard counters.**

---

## Internal Feature Names

| Feature | Convention | Status |
|---------|------------|--------|
| internal_introsort | internal_ prefix | OK |
| internal_merge_sort | internal_ prefix | OK |
| internal_heap_sort | internal_ prefix | OK |
| internal_insertion_sort | internal_ prefix | OK |
| list_to_array | noun_to_noun | OK |
| array_to_list | noun_to_noun | OK |
| heapify | verb (algorithm term) | OK |
| heapify_range | verb_noun | OK |
| swap | verb | OK |
| partition | noun/verb (algorithm term) | OK |
| merge | verb (algorithm term) | OK |
| merge_sort_range | verb_noun | OK |
| insertion_sort_range | verb_noun | OK |
| heap_sort_range | verb_noun | OK |
| median_of_three | noun_of_noun | OK |
| log2_floor | noun_noun | OK |

---

## Summary

| Category | Items Reviewed | Issues Found |
|----------|----------------|--------------|
| Class names | 6 | 0 |
| Feature names | 25+ | 0 |
| Parameter names | 10+ | 0 |
| Local variables | 10+ | 0 |
| Internal features | 15+ | 0 |

**Naming Review Rating: A**

All names follow Eiffel and simple_* ecosystem conventions.
