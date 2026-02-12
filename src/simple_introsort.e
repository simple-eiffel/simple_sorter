note
	description: "Introsort - hybrid quicksort/heapsort/insertion sort with O(n log n) worst case"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_INTROSORT [G -> detachable separate ANY]

inherit
	SIMPLE_SORT_ALGORITHM [G]

feature -- Access

	name: STRING = "Introsort"
			-- <Precursor>

	is_stable: BOOLEAN = False
			-- <Precursor>

	time_complexity: STRING = "O(n log n)"
			-- <Precursor>

	space_complexity: STRING = "O(log n)"
			-- <Precursor>

feature -- Constants

	Insertion_threshold: INTEGER = 16
			-- Switch to insertion sort below this size.

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort `a_array` by `a_key` using introsort.
			-- <Precursor>
		local
			l_max_depth: INTEGER
			l_n: INTEGER
		do
			l_n := a_array.count
			if l_n > 1 then
				l_max_depth := 2 * log2_floor (l_n)
				introsort_range (a_array, a_array.lower, a_array.upper, l_max_depth, a_key, a_descending)
			end
		ensure then
			stability_not_guaranteed: True -- Introsort is NOT stable (quicksort-based)
		end

feature {NONE} -- Implementation

	introsort_range (a_array: ARRAY [G]; a_left, a_right, a_depth_limit: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort range [a_left, a_right] with depth limiting.
		require
			left_valid: a_array.valid_index (a_left)
			right_valid: a_array.valid_index (a_right)
			depth_non_negative: a_depth_limit >= 0
		local
			l_size, l_pivot: INTEGER
		do
			l_size := a_right - a_left + 1
			if l_size <= Insertion_threshold then
				insertion_sort_range (a_array, a_left, a_right, a_key, a_descending)
			elseif a_depth_limit = 0 then
				heap_sort_range (a_array, a_left, a_right, a_key, a_descending)
			else
				l_pivot := partition (a_array, a_left, a_right, a_key, a_descending)
				if l_pivot > a_left then
					introsort_range (a_array, a_left, l_pivot - 1, a_depth_limit - 1, a_key, a_descending)
				end
				if l_pivot < a_right then
					introsort_range (a_array, l_pivot + 1, a_right, a_depth_limit - 1, a_key, a_descending)
				end
			end
		end

	partition (a_array: ARRAY [G]; a_left, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN): INTEGER
			-- Partition array and return pivot index.
		require
			left_valid: a_array.valid_index (a_left)
			right_valid: a_array.valid_index (a_right)
			range_valid: a_left < a_right
		local
			l_pivot_idx, i, j: INTEGER
			l_pivot_key, l_current_key: COMPARABLE
			l_should_swap: BOOLEAN
		do
			-- Median-of-three pivot selection
			l_pivot_idx := median_of_three (a_array, a_left, a_right, a_key, a_descending)
			swap (a_array, l_pivot_idx, a_right)
			l_pivot_key := a_key.item ([a_array [a_right]])

			i := a_left
			from
				j := a_left
			until
				j >= a_right
			loop
				l_current_key := a_key.item ([a_array [j]])
				if a_descending then
					l_should_swap := l_current_key > l_pivot_key
				else
					l_should_swap := l_current_key < l_pivot_key
				end
				if l_should_swap then
					swap (a_array, i, j)
					i := i + 1
				end
				j := j + 1
			end
			swap (a_array, i, a_right)
			Result := i
		ensure
			result_in_range: Result >= a_left and Result <= a_right
		end

	median_of_three (a_array: ARRAY [G]; a_left, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN): INTEGER
			-- Return index of median of first, middle, last elements.
			-- Note: median selection is direction-independent.
		local
			l_mid: INTEGER
			l_left_key, l_mid_key, l_right_key: COMPARABLE
		do
			l_mid := a_left + (a_right - a_left) // 2
			l_left_key := a_key.item ([a_array [a_left]])
			l_mid_key := a_key.item ([a_array [l_mid]])
			l_right_key := a_key.item ([a_array [a_right]])

			if (l_left_key <= l_mid_key and l_mid_key <= l_right_key) or
			   (l_right_key <= l_mid_key and l_mid_key <= l_left_key) then
				Result := l_mid
			elseif (l_mid_key <= l_left_key and l_left_key <= l_right_key) or
			       (l_right_key <= l_left_key and l_left_key <= l_mid_key) then
				Result := a_left
			else
				Result := a_right
			end
		end

	heap_sort_range (a_array: ARRAY [G]; a_left, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Heap sort fallback for deep recursion.
		local
			l_size, i: INTEGER
		do
			l_size := a_right - a_left + 1
			-- Build heap
			from
				i := l_size // 2 - 1
			until
				i < 0
			loop
				heapify (a_array, a_left, l_size, i, a_key, a_descending)
				i := i - 1
			end
			-- Extract elements
			from
				i := l_size - 1
			until
				i < 1
			loop
				swap (a_array, a_left, a_left + i)
				heapify (a_array, a_left, i, 0, a_key, a_descending)
				i := i - 1
			end
		end

	log2_floor (a_n: INTEGER): INTEGER
			-- Floor of log base 2 of `a_n`.
		require
			n_positive: a_n > 0
		local
			l_n: INTEGER
		do
			from
				l_n := a_n
			until
				l_n <= 1
			loop
				l_n := l_n // 2
				Result := Result + 1
			end
		ensure
			result_non_negative: Result >= 0
		end

end
