note
	description: "Comprehensive test cases for SIMPLE_SORTER"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Basic sorting tests

	test_sort_integers_ascending
			-- Test sorting integers ascending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9, 3>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("asc_1", l_list [1] = 1)
			assert ("asc_2", l_list [2] = 2)
			assert ("asc_3", l_list [3] = 3)
			assert ("asc_4", l_list [4] = 5)
			assert ("asc_5", l_list [5] = 8)
			assert ("asc_6", l_list [6] = 9)
		end

	test_sort_integers_descending
			-- Test sorting integers descending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9, 3>>)
			l_sorter.sort_by_descending (l_list, agent identity_int)
			assert ("desc_1", l_list [1] = 9)
			assert ("desc_2", l_list [2] = 8)
			assert ("desc_3", l_list [3] = 5)
			assert ("desc_4", l_list [4] = 3)
			assert ("desc_5", l_list [5] = 2)
			assert ("desc_6", l_list [6] = 1)
		end

	test_sort_strings
			-- Test sorting strings.
		local
			l_sorter: SIMPLE_SORTER [STRING]
			l_list: ARRAYED_LIST [STRING]
		do
			create l_sorter.make
			create l_list.make_from_array (<<"cherry", "apple", "banana">>)
			l_sorter.sort_by (l_list, agent identity_string)
			assert ("str_1", l_list [1].is_equal ("apple"))
			assert ("str_2", l_list [2].is_equal ("banana"))
			assert ("str_3", l_list [3].is_equal ("cherry"))
		end

	test_sort_empty_list
			-- Test sorting empty list does not crash.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make (0)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("empty", l_list.is_empty)
		end

	test_sort_single_element
			-- Test sorting single element.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<42>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("single_count", l_list.count = 1)
			assert ("single_val", l_list [1] = 42)
		end

	test_sort_already_sorted
			-- Test sorting already sorted list.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<1, 2, 3, 4, 5>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("sorted_first", l_list [1] = 1)
			assert ("sorted_last", l_list [5] = 5)
		end

	test_sort_reverse_sorted
			-- Test sorting reverse-sorted list.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<5, 4, 3, 2, 1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("rev_first", l_list [1] = 1)
			assert ("rev_last", l_list [5] = 5)
		end

	test_sort_duplicates
			-- Test sorting with duplicate elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<3, 1, 4, 1, 5, 9, 2, 6, 5, 3>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("dup_1", l_list [1] = 1)
			assert ("dup_2", l_list [2] = 1)
			assert ("dup_9", l_list [9] = 6)
			assert ("dup_10", l_list [10] = 9)
		end

feature -- Algorithm-specific tests

	test_insertion_sort
			-- Test insertion sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make_with_algorithm (create {SIMPLE_INSERTION_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("insertion_sorted", l_sorter.is_sorted (l_list, agent identity_int))
		end

	test_heap_sort
			-- Test heap sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make_with_algorithm (create {SIMPLE_HEAP_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("heap_sorted", l_sorter.is_sorted (l_list, agent identity_int))
		end

	test_merge_sort
			-- Test merge sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("merge_sorted", l_sorter.is_sorted (l_list, agent identity_int))
		end

	test_introsort
			-- Test introsort algorithm (default).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("intro_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("intro_is_default", l_sorter.is_introsort)
		end

feature -- Stable sort tests

	test_stable_sort
			-- Test stable sort preserves order of equal elements.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [name: STRING; priority: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [name: STRING; priority: INTEGER]]
			l_t1, l_t2, l_t3, l_t4: TUPLE [name: STRING; priority: INTEGER]
		do
			create l_sorter.make
			l_t1 := ["Alice", 1]
			l_t2 := ["Bob", 2]
			l_t3 := ["Carol", 1]
			l_t4 := ["Dave", 2]
			create l_list.make_from_array (<<l_t1, l_t2, l_t3, l_t4>>)
			l_sorter.sort_by_stable (l_list, agent priority_key)
			assert ("stable_1", l_list [1].name.is_equal ("Alice"))
			assert ("stable_2", l_list [2].name.is_equal ("Carol"))
			assert ("stable_3", l_list [3].name.is_equal ("Bob"))
			assert ("stable_4", l_list [4].name.is_equal ("Dave"))
		end

feature -- Array tests

	test_sort_array
			-- Test sorting array directly.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_array: ARRAY [INTEGER]
		do
			create l_sorter.make
			l_array := <<5, 2, 8, 1, 9>>
			l_sorter.sort_array_by (l_array, agent identity_int)
			assert ("array_sorted", l_sorter.is_array_sorted (l_array, agent identity_int))
		end

	test_sort_array_descending
			-- Test sorting array descending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_array: ARRAY [INTEGER]
		do
			create l_sorter.make
			l_array := <<5, 2, 8, 1, 9>>
			l_sorter.sort_array_by_descending (l_array, agent identity_int)
			assert ("array_desc_first", l_array [1] = 9)
			assert ("array_desc_last", l_array [5] = 1)
		end

feature -- Algorithm property tests

	test_algorithm_properties
			-- Test algorithm property queries.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
		do
			create l_sorter.make
			assert ("introsort_name", l_sorter.introsort.name.is_equal ("Introsort"))
			assert ("introsort_unstable", not l_sorter.introsort.is_stable)
			assert ("merge_stable", l_sorter.merge_sort.is_stable)
			assert ("insertion_stable", l_sorter.insertion_sort.is_stable)
			assert ("heap_unstable", not l_sorter.heap_sort.is_stable)
		end

feature -- Large data tests

	test_large_data
			-- Test sorting large dataset.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i: INTEGER
		do
			create l_sorter.make
			create l_list.make (1000)
			create l_rand.make
			from i := 1 until i > 1000 loop
				l_rand.forth
				l_list.extend (l_rand.item \\ 10000)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("large_sorted", l_sorter.is_sorted (l_list, agent identity_int))
		end

feature -- Status report tests

	test_is_sorted
			-- Test is_sorted query.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_sorted, l_unsorted: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_sorted.make_from_array (<<1, 2, 3, 4, 5>>)
			create l_unsorted.make_from_array (<<5, 2, 8, 1, 9>>)
			assert ("sorted_yes", l_sorter.is_sorted (l_sorted, agent identity_int))
			assert ("sorted_no", not l_sorter.is_sorted (l_unsorted, agent identity_int))
		end

	test_is_sorted_descending
			-- Test is_sorted_descending query.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_sorted, l_unsorted: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_sorted.make_from_array (<<5, 4, 3, 2, 1>>)
			create l_unsorted.make_from_array (<<1, 2, 3, 4, 5>>)
			assert ("desc_yes", l_sorter.is_sorted_descending (l_sorted, agent identity_int))
			assert ("desc_no", not l_sorter.is_sorted_descending (l_unsorted, agent identity_int))
		end

feature -- Algorithm change tests

	test_set_algorithm
			-- Test changing algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
		do
			create l_sorter.make
			assert ("default_introsort", l_sorter.is_introsort)
			l_sorter.set_algorithm (l_sorter.merge_sort)
			assert ("now_stable", l_sorter.is_stable)
			assert ("not_introsort", not l_sorter.is_introsort)
		end

feature -- Multi-key sorting tests

	test_sort_by_keys_two_keys
			-- Test sort_by_keys with two keys (name asc, age desc).
		local
			l_sorter: SIMPLE_SORTER [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["Bob", 30, 85],
				["Alice", 25, 90],
				["Alice", 30, 88],
				["Bob", 25, 92]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent name_key, agent age_key>>,
				<<False, True>>)
			assert ("2k_1_name", l_list [1].name.is_equal ("Alice"))
			assert ("2k_1_age", l_list [1].age = 30)
			assert ("2k_2_age", l_list [2].age = 25)
			assert ("2k_3_name", l_list [3].name.is_equal ("Bob"))
			assert ("2k_3_age", l_list [3].age = 30)
			assert ("2k_4_age", l_list [4].age = 25)
		end

	test_sort_by_keys_three_keys
			-- Test sort_by_keys with three keys.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["Alice", 25, 90],
				["Alice", 25, 85],
				["Alice", 25, 95],
				["Bob", 25, 90]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent name_key, agent age_key, agent score_key>>,
				<<False, False, True>>)
			assert ("3k_1_score", l_list [1].score = 95)
			assert ("3k_2_score", l_list [2].score = 90)
			assert ("3k_3_score", l_list [3].score = 85)
			assert ("3k_4_name", l_list [4].name.is_equal ("Bob"))
		end

	test_sort_by_keys_mixed_directions
			-- Test sort_by_keys with all descending.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [name: STRING; age: INTEGER; score: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["Alice", 25, 90],
				["Bob", 30, 85],
				["Carol", 20, 95]
			>>)
			l_sorter.sort_by_keys (l_list, <<agent name_key>>, <<True>>)
			assert ("mixed_1", l_list [1].name.is_equal ("Carol"))
			assert ("mixed_2", l_list [2].name.is_equal ("Bob"))
			assert ("mixed_3", l_list [3].name.is_equal ("Alice"))
		end

feature -- Adversarial edge case tests

	test_all_same_elements
			-- Test sorting array of identical elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<7, 7, 7, 7, 7, 7, 7, 7>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("same_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("same_count", l_list.count = 8)
		end

	test_two_elements
			-- Test sorting exactly two elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<2, 1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("two_1", l_list [1] = 1)
			assert ("two_2", l_list [2] = 2)
		end

	test_negative_numbers
			-- Test sorting negative numbers.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<-5, 3, -1, 0, -10, 7>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("neg_first", l_list [1] = -10)
			assert ("neg_second", l_list [2] = -5)
			assert ("neg_last", l_list [6] = 7)
		end

	test_extreme_values
			-- Test sorting with INTEGER min/max values.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<0, {INTEGER}.max_value, {INTEGER}.min_value, 1, -1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("extreme_first", l_list [1] = {INTEGER}.min_value)
			assert ("extreme_last", l_list [5] = {INTEGER}.max_value)
		end

	test_alternating_sequence
			-- Test sorting alternating high-low sequence.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			create l_sorter.make
			create l_list.make_from_array (<<100, 1, 99, 2, 98, 3, 97, 4>>)
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("alt_sorted", l_sorter.is_sorted (l_list, agent identity_int))
		end

feature -- Adversarial stress tests

	test_large_ascending
			-- Test sorting already-sorted large array.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create l_sorter.make
			create l_list.make (100)
			from i := 1 until i > 100 loop
				l_list.extend (i)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("lg_asc_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("lg_asc_count", l_list.count = 100)
		end

	test_large_descending
			-- Test sorting reverse-sorted large array (worst case for naive quicksort).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			create l_sorter.make
			create l_list.make (100)
			from i := 100 until i < 1 loop
				l_list.extend (i)
				i := i - 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("lg_desc_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("lg_desc_count", l_list.count = 100)
		end

	test_large_random
			-- Test sorting large random array.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i: INTEGER
		do
			create l_sorter.make
			create l_list.make (100)
			create l_rand.make
			from i := 1 until i > 100 loop
				l_rand.forth
				l_list.extend (l_rand.item \\ 100)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("lg_rand_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("lg_rand_count", l_list.count = 100)
		end

feature -- Algorithm-specific stress tests

	test_introsort_depth_trigger
			-- Test that introsort handles pathological cases (triggers heap sort fallback).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i: INTEGER
		do
			create l_sorter.make
			create l_list.make (1000)
			create l_rand.set_seed (42)
			from i := 1 until i > 1000 loop
				l_rand.forth
				l_list.extend (l_rand.item)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			assert ("depth_sorted", l_sorter.is_sorted (l_list, agent identity_int))
			assert ("depth_count", l_list.count = 1000)
		end

	test_merge_sort_stability_preserved
			-- Test that merge sort preserves order of equal elements.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [id: INTEGER; priority: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [id: INTEGER; priority: INTEGER]]
			l_t1, l_t2, l_t3, l_t4, l_t5, l_t6: TUPLE [id: INTEGER; priority: INTEGER]
		do
			l_t1 := [1, 2]
			l_t2 := [2, 1]
			l_t3 := [3, 2]
			l_t4 := [4, 1]
			l_t5 := [5, 3]
			l_t6 := [6, 2]
			create l_list.make_from_array (<<l_t1, l_t2, l_t3, l_t4, l_t5, l_t6>>)
			create l_sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [TUPLE [id: INTEGER; priority: INTEGER]]})
			l_sorter.sort_by (l_list, agent id_priority_key)
			assert ("stab_pri1_id2", l_list [1].id = 2)
			assert ("stab_pri1_id4", l_list [2].id = 4)
			assert ("stab_pri2_id1", l_list [3].id = 1)
			assert ("stab_pri2_id3", l_list [4].id = 3)
			assert ("stab_pri2_id6", l_list [5].id = 6)
			assert ("stab_pri3_id5", l_list [6].id = 5)
		end

feature -- Multi-key adversarial tests

	test_sort_by_keys_empty_list
			-- Test sort_by_keys on empty list.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			create l_sorter.make
			create l_list.make (0)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, False>>)
			assert ("mk_empty", l_list.is_empty)
		end

	test_sort_by_keys_single_element
			-- Test sort_by_keys on single-element list.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<["only", 42, 100]>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, True>>)
			assert ("mk_single_count", l_list.count = 1)
			assert ("mk_single_val", l_list [1].a.is_equal ("only"))
		end

	test_sort_by_keys_all_equal_primary
			-- Test sort_by_keys where all elements have same primary key.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["same", 30, 1],
				["same", 10, 2],
				["same", 20, 3],
				["same", 40, 4]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, False>>)
			assert ("mk_eq_1", l_list [1].b = 10)
			assert ("mk_eq_2", l_list [2].b = 20)
			assert ("mk_eq_3", l_list [3].b = 30)
			assert ("mk_eq_4", l_list [4].b = 40)
		end

	test_sort_by_keys_all_equal_all_keys
			-- Test sort_by_keys where all elements are equal on all keys.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["same", 42, 100],
				["same", 42, 100],
				["same", 42, 100]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b, agent field_c>>,
				<<False, False, False>>)
			assert ("mk_all_eq_count", l_list.count = 3)
			assert ("mk_all_eq_val", l_list [1].a.is_equal ("same"))
		end

	test_sort_by_keys_many_keys
			-- Test sort_by_keys with tie-breaking across three keys.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			create l_sorter.make
			create l_list.make_from_array (<<
				["A", 1, 300],
				["A", 1, 100],
				["A", 1, 200],
				["A", 2, 50],
				["B", 1, 999]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b, agent field_c>>,
				<<False, False, False>>)
			assert ("mk_many_1c", l_list [1].c = 100)
			assert ("mk_many_2c", l_list [2].c = 200)
			assert ("mk_many_3c", l_list [3].c = 300)
			assert ("mk_many_4b", l_list [4].b = 2)
			assert ("mk_many_5a", l_list [5].a.is_equal ("B"))
		end

feature {NONE} -- Key extractors

	identity_int (a_int: INTEGER): INTEGER
		do
			Result := a_int
		end

	identity_string (a_string: STRING): STRING
		do
			Result := a_string
		end

	priority_key (a_tuple: TUPLE [name: STRING; priority: INTEGER]): INTEGER
		do
			Result := a_tuple.priority
		end

	id_priority_key (a_tuple: TUPLE [id: INTEGER; priority: INTEGER]): INTEGER
		do
			Result := a_tuple.priority
		end

	name_key (a_tuple: TUPLE [name: STRING; age: INTEGER; score: INTEGER]): STRING
		do
			Result := a_tuple.name
		end

	age_key (a_tuple: TUPLE [name: STRING; age: INTEGER; score: INTEGER]): INTEGER
		do
			Result := a_tuple.age
		end

	score_key (a_tuple: TUPLE [name: STRING; age: INTEGER; score: INTEGER]): INTEGER
		do
			Result := a_tuple.score
		end

	field_a (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): STRING
		do
			Result := a_tuple.a
		end

	field_b (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): INTEGER
		do
			Result := a_tuple.b
		end

	field_c (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): INTEGER
		do
			Result := a_tuple.c
		end

end
