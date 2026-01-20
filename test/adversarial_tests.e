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
			create l_list.make (5000)
			from i := 1 until i > 5000 loop
				l_list.extend (i)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 5000
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
			create l_list.make (5000)
			from i := 5000 until i < 1 loop
				l_list.extend (i)
				i := i - 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 5000
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
			create l_list.make (10000)
			create l_rand.make
			from i := 1 until i > 10000 loop
				l_rand.forth
				l_list.extend (l_rand.item \\ 1000000)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_list.count = 10000
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
			n := 100000  -- Large enough to potentially trigger depth limit
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
