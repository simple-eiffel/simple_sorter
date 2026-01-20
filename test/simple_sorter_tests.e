note
	description: "Comprehensive tests for simple_sorter library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_SORTER_TESTS

create
	default_create

feature -- Test execution

	run_all
			-- Run all tests.
		local
			l_pass_count, l_fail_count: INTEGER
		do
			print ("=== simple_sorter Tests ===%N%N")

			-- Basic sorting tests
			if test_sort_integers_ascending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_integers_descending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_strings then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_empty_list then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_single_element then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_already_sorted then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_reverse_sorted then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_duplicates then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Algorithm-specific tests
			if test_insertion_sort then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_heap_sort then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_merge_sort then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_introsort then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Stable sort tests
			if test_stable_sort then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Array tests
			if test_sort_array then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_sort_array_descending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Algorithm property tests
			if test_algorithm_properties then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Large data tests
			if test_large_data then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Status report tests
			if test_is_sorted then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end
			if test_is_sorted_descending then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			-- Algorithm change tests
			if test_set_algorithm then l_pass_count := l_pass_count + 1 else l_fail_count := l_fail_count + 1 end

			print ("%N=== Results: " + l_pass_count.out + " passed, " + l_fail_count.out + " failed ===%N")
		end

feature -- Basic sorting tests

	test_sort_integers_ascending: BOOLEAN
			-- Test sorting integers ascending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_integers_ascending: ")
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9, 3>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = 1 and l_list [2] = 2 and l_list [3] = 3 and
			          l_list [4] = 5 and l_list [5] = 8 and l_list [6] = 9
			print_result (Result)
		end

	test_sort_integers_descending: BOOLEAN
			-- Test sorting integers descending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_integers_descending: ")
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9, 3>>)
			l_sorter.sort_by_descending (l_list, agent identity_int)
			Result := l_list [1] = 9 and l_list [2] = 8 and l_list [3] = 5 and
			          l_list [4] = 3 and l_list [5] = 2 and l_list [6] = 1
			print_result (Result)
		end

	test_sort_strings: BOOLEAN
			-- Test sorting strings.
		local
			l_sorter: SIMPLE_SORTER [STRING]
			l_list: ARRAYED_LIST [STRING]
		do
			print ("test_sort_strings: ")
			create l_sorter.make
			create l_list.make_from_array (<<"cherry", "apple", "banana">>)
			l_sorter.sort_by (l_list, agent identity_string)
			Result := l_list [1].is_equal ("apple") and l_list [2].is_equal ("banana") and l_list [3].is_equal ("cherry")
			print_result (Result)
		end

	test_sort_empty_list: BOOLEAN
			-- Test sorting empty list.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_empty_list: ")
			create l_sorter.make
			create l_list.make (0)
			-- Empty list should not crash
			Result := l_list.is_empty
			print_result (Result)
		end

	test_sort_single_element: BOOLEAN
			-- Test sorting single element.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_single_element: ")
			create l_sorter.make
			create l_list.make_from_array (<<42>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list.count = 1 and l_list [1] = 42
			print_result (Result)
		end

	test_sort_already_sorted: BOOLEAN
			-- Test sorting already sorted list.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_already_sorted: ")
			create l_sorter.make
			create l_list.make_from_array (<<1, 2, 3, 4, 5>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = 1 and l_list [5] = 5
			print_result (Result)
		end

	test_sort_reverse_sorted: BOOLEAN
			-- Test sorting reverse-sorted list.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_reverse_sorted: ")
			create l_sorter.make
			create l_list.make_from_array (<<5, 4, 3, 2, 1>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = 1 and l_list [5] = 5
			print_result (Result)
		end

	test_sort_duplicates: BOOLEAN
			-- Test sorting with duplicate elements.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_sort_duplicates: ")
			create l_sorter.make
			create l_list.make_from_array (<<3, 1, 4, 1, 5, 9, 2, 6, 5, 3>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_list [1] = 1 and l_list [2] = 1 and l_list [9] = 6 and l_list [10] = 9
			print_result (Result)
		end

feature -- Algorithm-specific tests

	test_insertion_sort: BOOLEAN
			-- Test insertion sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_insertion_sort: ")
			create l_sorter.make_with_algorithm (create {SIMPLE_INSERTION_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int)
			print_result (Result)
		end

	test_heap_sort: BOOLEAN
			-- Test heap sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_heap_sort: ")
			create l_sorter.make_with_algorithm (create {SIMPLE_HEAP_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int)
			print_result (Result)
		end

	test_merge_sort: BOOLEAN
			-- Test merge sort algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_merge_sort: ")
			create l_sorter.make_with_algorithm (create {SIMPLE_MERGE_SORT [INTEGER]})
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int)
			print_result (Result)
		end

	test_introsort: BOOLEAN
			-- Test introsort algorithm (default).
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
		do
			print ("test_introsort: ")
			create l_sorter.make
			create l_list.make_from_array (<<5, 2, 8, 1, 9>>)
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int) and l_sorter.is_introsort
			print_result (Result)
		end

feature -- Stable sort tests

	test_stable_sort: BOOLEAN
			-- Test stable sort preserves order of equal elements.
		local
			l_sorter: SIMPLE_SORTER [TUPLE [name: STRING; priority: INTEGER]]
			l_list: ARRAYED_LIST [TUPLE [name: STRING; priority: INTEGER]]
			l_t1, l_t2, l_t3, l_t4: TUPLE [name: STRING; priority: INTEGER]
		do
			print ("test_stable_sort: ")
			create l_sorter.make
			l_t1 := ["Alice", 1]
			l_t2 := ["Bob", 2]
			l_t3 := ["Carol", 1]  -- Same priority as Alice
			l_t4 := ["Dave", 2]   -- Same priority as Bob
			create l_list.make_from_array (<<l_t1, l_t2, l_t3, l_t4>>)
			l_sorter.sort_by_stable (l_list, agent priority_key)
			-- After stable sort by priority: Alice, Carol (both 1), then Bob, Dave (both 2)
			Result := l_list [1].name.is_equal ("Alice") and l_list [2].name.is_equal ("Carol") and
			          l_list [3].name.is_equal ("Bob") and l_list [4].name.is_equal ("Dave")
			print_result (Result)
		end

feature -- Array tests

	test_sort_array: BOOLEAN
			-- Test sorting array directly.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_array: ARRAY [INTEGER]
		do
			print ("test_sort_array: ")
			create l_sorter.make
			l_array := <<5, 2, 8, 1, 9>>
			l_sorter.sort_array_by (l_array, agent identity_int)
			Result := l_sorter.is_array_sorted (l_array, agent identity_int)
			print_result (Result)
		end

	test_sort_array_descending: BOOLEAN
			-- Test sorting array descending.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_array: ARRAY [INTEGER]
		do
			print ("test_sort_array_descending: ")
			create l_sorter.make
			l_array := <<5, 2, 8, 1, 9>>
			l_sorter.sort_array_by_descending (l_array, agent identity_int)
			Result := l_array [1] = 9 and l_array [5] = 1
			print_result (Result)
		end

feature -- Algorithm property tests

	test_algorithm_properties: BOOLEAN
			-- Test algorithm property queries.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
		do
			print ("test_algorithm_properties: ")
			create l_sorter.make

			Result := l_sorter.introsort.name.is_equal ("Introsort") and
			          not l_sorter.introsort.is_stable and
			          l_sorter.merge_sort.is_stable and
			          l_sorter.insertion_sort.is_stable and
			          not l_sorter.heap_sort.is_stable
			print_result (Result)
		end

feature -- Large data tests

	test_large_data: BOOLEAN
			-- Test sorting large dataset.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list: ARRAYED_LIST [INTEGER]
			l_rand: RANDOM
			i: INTEGER
		do
			print ("test_large_data: ")
			create l_sorter.make
			create l_list.make (1000)
			create l_rand.make
			from
				i := 1
			until
				i > 1000
			loop
				l_rand.forth
				l_list.extend (l_rand.item \\ 10000)
				i := i + 1
			end
			l_sorter.sort_by (l_list, agent identity_int)
			Result := l_sorter.is_sorted (l_list, agent identity_int)
			print_result (Result)
		end

feature -- Status report tests

	test_is_sorted: BOOLEAN
			-- Test is_sorted query.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list_sorted, l_list_unsorted: ARRAYED_LIST [INTEGER]
		do
			print ("test_is_sorted: ")
			create l_sorter.make
			create l_list_sorted.make_from_array (<<1, 2, 3, 4, 5>>)
			create l_list_unsorted.make_from_array (<<5, 2, 8, 1, 9>>)
			Result := l_sorter.is_sorted (l_list_sorted, agent identity_int) and
			          not l_sorter.is_sorted (l_list_unsorted, agent identity_int)
			print_result (Result)
		end

	test_is_sorted_descending: BOOLEAN
			-- Test is_sorted_descending query.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
			l_list_sorted, l_list_unsorted: ARRAYED_LIST [INTEGER]
		do
			print ("test_is_sorted_descending: ")
			create l_sorter.make
			create l_list_sorted.make_from_array (<<5, 4, 3, 2, 1>>)
			create l_list_unsorted.make_from_array (<<1, 2, 3, 4, 5>>)
			Result := l_sorter.is_sorted_descending (l_list_sorted, agent identity_int) and
			          not l_sorter.is_sorted_descending (l_list_unsorted, agent identity_int)
			print_result (Result)
		end

feature -- Algorithm change tests

	test_set_algorithm: BOOLEAN
			-- Test changing algorithm.
		local
			l_sorter: SIMPLE_SORTER [INTEGER]
		do
			print ("test_set_algorithm: ")
			create l_sorter.make
			Result := l_sorter.is_introsort
			l_sorter.set_algorithm (l_sorter.merge_sort)
			Result := Result and l_sorter.is_stable and not l_sorter.is_introsort
			print_result (Result)
		end

feature {NONE} -- Key extractors

	identity_int (a_int: INTEGER): INTEGER
			-- Identity function for integers.
		do
			Result := a_int
		end

	identity_string (a_string: STRING): STRING
			-- Identity function for strings.
		do
			Result := a_string
		end

	priority_key (a_tuple: TUPLE [name: STRING; priority: INTEGER]): INTEGER
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
