note
	description: "Test application for SIMPLE_SORTER"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running SIMPLE_SORTER tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_lib_tests
		do
			create lib_tests

			-- Basic sorting (8)
			run_test (agent lib_tests.test_sort_integers_ascending, "test_sort_integers_ascending")
			run_test (agent lib_tests.test_sort_integers_descending, "test_sort_integers_descending")
			run_test (agent lib_tests.test_sort_strings, "test_sort_strings")
			run_test (agent lib_tests.test_sort_empty_list, "test_sort_empty_list")
			run_test (agent lib_tests.test_sort_single_element, "test_sort_single_element")
			run_test (agent lib_tests.test_sort_already_sorted, "test_sort_already_sorted")
			run_test (agent lib_tests.test_sort_reverse_sorted, "test_sort_reverse_sorted")
			run_test (agent lib_tests.test_sort_duplicates, "test_sort_duplicates")

			-- Algorithm-specific (4)
			run_test (agent lib_tests.test_insertion_sort, "test_insertion_sort")
			run_test (agent lib_tests.test_heap_sort, "test_heap_sort")
			run_test (agent lib_tests.test_merge_sort, "test_merge_sort")
			run_test (agent lib_tests.test_introsort, "test_introsort")

			-- Stable sort (1)
			run_test (agent lib_tests.test_stable_sort, "test_stable_sort")

			-- Array tests (2)
			run_test (agent lib_tests.test_sort_array, "test_sort_array")
			run_test (agent lib_tests.test_sort_array_descending, "test_sort_array_descending")

			-- Algorithm properties (1)
			run_test (agent lib_tests.test_algorithm_properties, "test_algorithm_properties")

			-- Large data (1)
			run_test (agent lib_tests.test_large_data, "test_large_data")

			-- Status reports (2)
			run_test (agent lib_tests.test_is_sorted, "test_is_sorted")
			run_test (agent lib_tests.test_is_sorted_descending, "test_is_sorted_descending")

			-- Algorithm change (1)
			run_test (agent lib_tests.test_set_algorithm, "test_set_algorithm")

			-- Multi-key sorting (3)
			run_test (agent lib_tests.test_sort_by_keys_two_keys, "test_sort_by_keys_two_keys")
			run_test (agent lib_tests.test_sort_by_keys_three_keys, "test_sort_by_keys_three_keys")
			run_test (agent lib_tests.test_sort_by_keys_mixed_directions, "test_sort_by_keys_mixed_directions")

			-- Adversarial edge cases (5)
			run_test (agent lib_tests.test_all_same_elements, "test_all_same_elements")
			run_test (agent lib_tests.test_two_elements, "test_two_elements")
			run_test (agent lib_tests.test_negative_numbers, "test_negative_numbers")
			run_test (agent lib_tests.test_extreme_values, "test_extreme_values")
			run_test (agent lib_tests.test_alternating_sequence, "test_alternating_sequence")

			-- Adversarial stress (5)
			run_test (agent lib_tests.test_large_ascending, "test_large_ascending")
			run_test (agent lib_tests.test_large_descending, "test_large_descending")
			run_test (agent lib_tests.test_large_random, "test_large_random")
			run_test (agent lib_tests.test_introsort_depth_trigger, "test_introsort_depth_trigger")
			run_test (agent lib_tests.test_merge_sort_stability_preserved, "test_merge_sort_stability_preserved")

			-- Multi-key adversarial (5)
			run_test (agent lib_tests.test_sort_by_keys_empty_list, "test_sort_by_keys_empty_list")
			run_test (agent lib_tests.test_sort_by_keys_single_element, "test_sort_by_keys_single_element")
			run_test (agent lib_tests.test_sort_by_keys_all_equal_primary, "test_sort_by_keys_all_equal_primary")
			run_test (agent lib_tests.test_sort_by_keys_all_equal_all_keys, "test_sort_by_keys_all_equal_all_keys")
			run_test (agent lib_tests.test_sort_by_keys_many_keys, "test_sort_by_keys_many_keys")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS
	passed, failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
