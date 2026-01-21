note
	description: "Adversarial tests for simple_sorter library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	ADVERSARIAL_TESTS

create
	default_create

feature -- Test execution

	run_all
			-- Run all adversarial tests.
		local
			l_pass_count, l_fail_count: INTEGER
		do
			print ("=== Adversarial Tests ===%N%N")

			-- Edge case tests
			if test_all_same_elements then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_two_elements then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_negative_numbers then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_extreme_values then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_alternating_sequence then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Stress tests
			if test_large_ascending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_large_descending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_large_random then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Algorithm-specific stress
			if test_introsort_depth_trigger then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_merge_sort_stability_preserved then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Multi-key sorting adversarial tests (sort_by_keys)
			if test_sort_by_keys_empty_list then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_by_keys_single_element then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_by_keys_all_equal_primary then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_by_keys_all_equal_all_keys then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_by_keys_many_keys then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			print ("%N=== Adversarial Results: " + l_pass_count.out + " passed, " + l_fail_count.out + " failed ===%N")
		end

feature -- Edge case tests

	test_all_same_elements: BOOLEAN
			-- Test sorting array of identical elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_all_same_elements: ")
			create l_sorter.make
			create l_list.make_from_array (<<7, 7, 7, 7, 7, 7, 7, 7>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 8
			print_result (Result)
		end

	test_two_elements: BOOLEAN
			-- Test sorting exactly two elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_two_elements: ")
			create l_sorter.make
			create l_list.make_from_array (<<2, 1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = 1 and l_list [2] = 2
			print_result (Result)
		end

	test_negative_numbers: BOOLEAN
			-- Test sorting negative numbers.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_negative_numbers: ")
			create l_sorter.make
			create l_list.make_from_array (<<-5, 3, -1, 0, -10, 7>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = -10 and l_list [2] = -5 and l_list [6] = 7
			print_result (Result)
		end

	test_extreme_values: BOOLEAN
			-- Test sorting with INTEGER min/max values.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_min, l_max: INTEGER
		do
			print ("test_extreme_values: ")
			l_min := {INTEGER}.min_value
			l_max := {INTEGER}.max_value
			create l_sorter.make
			create l_list.make_from_array (<<0, l_max, l_min, 1, -1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = l_min and l_list [5] = l_max
			print_result (Result)
		end

	test_alternating_sequence: BOOLEAN
			-- Test sorting alternating high-low sequence.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_alternating_sequence: ")
			create l_sorter.make
			create l_list.make_from_array (<<100, 1, 99, 2, 98, 3, 97, 4>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int)
			print_result (Result)
		end

feature -- Stress tests

	test_large_ascending: BOOLEAN
			-- Test sorting already-sorted large array.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("test_large_ascending: ")
			create l_sorter.make
			create l_list.make (100)
			from i := 1 until i > 100 loop
				l_list.extend (i)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 100
			print_result (Result)
		end

	test_large_descending: BOOLEAN
			-- Test sorting reverse-sorted large array (worst case for naive quicksort).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			i: INTEGER
		do
			print ("test_large_descending: ")
			create l_sorter.make
			create l_list.make (100)
			from i := 100 until i < 1 loop
				l_list.extend (i)
				i := i - 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 100
			print_result (Result)
		end

	test_large_random: BOOLEAN
			-- Test sorting large random array.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i: INTEGER
		do
			print ("test_large_random: ")
			create l_sorter.make
			create l_list.make (100)
			create l_rand.make
			from i := 1 until i > 100 loop
				l_rand.forth
				l_list.extend (l_rand.item \\ 100)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 100
			print_result (Result)
		end

feature -- Algorithm-specific tests

	test_introsort_depth_trigger: BOOLEAN
			-- Test that introsort handles pathological cases (triggers heap sort fallback).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i, n: INTEGER
		do
			print ("test_introsort_depth_trigger: ")
			n := 1000  -- Large enough to potentially trigger depth limit
			create l_sorter.make
			create l_list.make (n)
			create l_rand.set_seed (42)
			from i := 1 until i > n loop
				l_rand.forth
				l_list.extend (l_rand.item)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = n
			print_result (Result)
		end

	test_merge_sort_stability_preserved: BOOLEAN
			-- Test that merge sort preserves order of equal elements.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [id: INTEGER; priority: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [id: INTEGER; priority: INTEGER]]
			l_t1, l_t2, l_t3, l_t4, l_t5, l_t6: TUPLE [id: INTEGER; priority: INTEGER]
		do
			print ("test_merge_sort_stability_preserved: ")
			l_t1 := [1, 2]  -- id=1, priority=2
			l_t2 := [2, 1]  -- id=2, priority=1
			l_t3 := [3, 2]  -- id=3, priority=2 (same as t1)
			l_t4 := [4, 1]  -- id=4, priority=1 (same as t2)
			l_t5 := [5, 3]  -- id=5, priority=3
			l_t6 := [6, 2]  -- id=6, priority=2 (same as t1, t3)
			create l_list.make_from_array (<<l_t1, l_t2, l_t3, l_t4, l_t5, l_t6>>)

			create l_sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [TUPLE [id: INTEGER; priority: INTEGER]]})
			l_sorter.sort_by (l_list, agent priority_key)

			-- After stable sort by priority:
			-- priority=1: [2,1], [4,1] (original order preserved)
			-- priority=2: [1,2], [3,2], [6,2] (original order preserved)
			-- priority=3: [5,3]
			Result := l_list [1].id = 2 and l_list [2].id = 4 and  -- priority 1
			          l_list [3].id = 1 and l_list [4].id = 3 and l_list [5].id = 6 and  -- priority 2
			          l_list [6].id = 5  -- priority 3
			print_result (Result)
		end

feature -- Multi-key sorting adversarial tests

	test_sort_by_keys_empty_list: BOOLEAN
			-- Test sort_by_keys on empty list.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			print ("test_sort_by_keys_empty_list: ")
			create l_sorter.make
			create l_list.make (0)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, False>>)
			Result := l_list.is_empty
			print_result (Result)
		end

	test_sort_by_keys_single_element: BOOLEAN
			-- Test sort_by_keys on single-element list.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			print ("test_sort_by_keys_single_element: ")
			create l_sorter.make
			create l_list.make_from_array (<<["only", 42, 100]>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, True>>)
			Result := l_list.count = 1 and l_list [1].a.is_equal ("only")
			print_result (Result)
		end

	test_sort_by_keys_all_equal_primary: BOOLEAN
			-- Test sort_by_keys where all elements have same primary key.
			-- Secondary key should determine final order.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			print ("test_sort_by_keys_all_equal_primary: ")
			create l_sorter.make
			create l_list.make_from_array (<<
				["same", 30, 1],
				["same", 10, 2],
				["same", 20, 3],
				["same", 40, 4]
			>>)
			-- Sort by a (all equal), then by b ascending
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b>>,
				<<False, False>>)
			-- Should be sorted by b: 10, 20, 30, 40
			Result := l_list [1].b = 10 and l_list [2].b = 20 and
			          l_list [3].b = 30 and l_list [4].b = 40
			print_result (Result)
		end

	test_sort_by_keys_all_equal_all_keys: BOOLEAN
			-- Test sort_by_keys where all elements are equal on all keys.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			print ("test_sort_by_keys_all_equal_all_keys: ")
			create l_sorter.make
			create l_list.make_from_array (<<
				["same", 42, 100],
				["same", 42, 100],
				["same", 42, 100]
			>>)
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b, agent field_c>>,
				<<False, False, False>>)
			-- Count should be preserved
			Result := l_list.count = 3 and
			          l_list [1].a.is_equal ("same") and l_list [1].b = 42
			print_result (Result)
		end

	test_sort_by_keys_many_keys: BOOLEAN
			-- Test sort_by_keys with tie-breaking across three keys.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [a: STRING; b: INTEGER; c: INTEGER]]
		do
			print ("test_sort_by_keys_many_keys: ")
			create l_sorter.make
			create l_list.make_from_array (<<
				["A", 1, 300],
				["A", 1, 100],
				["A", 1, 200],
				["A", 2, 50],
				["B", 1, 999]
			>>)
			-- Sort by a asc, b asc, c asc
			l_sorter.sort_by_keys (l_list,
				<<agent field_a, agent field_b, agent field_c>>,
				<<False, False, False>>)
			-- Expected: A/1/100, A/1/200, A/1/300, A/2/50, B/1/999
			Result := l_list [1].a.is_equal ("A") and l_list [1].b = 1 and l_list [1].c = 100 and
			          l_list [2].c = 200 and l_list [3].c = 300 and
			          l_list [4].b = 2 and l_list [5].a.is_equal ("B")
			print_result (Result)
		end

feature {NONE} -- Key extractors

	identity_int (a_int: INTEGER): INTEGER
			-- Identity function for integers.
		do
			Result := a_int
		end

	priority_key (a_tuple: TUPLE [id: INTEGER; priority: INTEGER]): INTEGER
			-- Extract priority from tuple.
		do
			Result := a_tuple.priority
		end

	field_a (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): STRING
			-- Extract field a from tuple.
		do
			Result := a_tuple.a
		end

	field_b (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): INTEGER
			-- Extract field b from tuple.
		do
			Result := a_tuple.b
		end

	field_c (a_tuple: TUPLE [a: STRING; b: INTEGER; c: INTEGER]): INTEGER
			-- Extract field c from tuple.
		do
			Result := a_tuple.c
		end

feature {NONE} -- Output

	print_result (a_passed: BOOLEAN)
			-- Print test result.
		do
			if a_passed then
				print ("PASS%N")
			else
				print ("FAIL%N")
			end
		end

end
