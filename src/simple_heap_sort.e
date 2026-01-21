note
	description: "Heap sort algorithm - O(n log n), in-place, not stable"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_HEAP_SORT [G]

inherit
	SIMPLE_SORT_ALGORITHM [G]

feature -- Access

	name: STRING = "Heap Sort"
			-- <Precursor>

	is_stable: BOOLEAN = False
			-- <Precursor>

	time_complexity: STRING = "O(n log n)"
			-- <Precursor>

	space_complexity: STRING = "O(1)"
			-- <Precursor>

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort `a_array` by `a_key` using heap sort.
			-- <Precursor>
		local
			l_size, i: INTEGER
		do
			l_size := a_array.count
			if l_size > 1 then
				-- Build heap
				from
					i := l_size // 2 - 1
				until
					i < 0
				loop
					heapify (a_array, l_size, i, a_key, a_descending)
					i := i - 1
				end
				-- Extract elements from heap
				from
					i := l_size - 1
				until
					i < 1
				loop
					swap (a_array, a_array.lower, a_array.lower + i)
					heapify (a_array, i, 0, a_key, a_descending)
					i := i - 1
				end
			end
		ensure then
			stability_not_guaranteed: True -- Heap sort is NOT stable
		end

feature {NONE} -- Implementation

	heapify (a_array: ARRAY [G]; a_size, a_root: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Maintain heap property for subtree rooted at `a_root`.
		require
			size_valid: a_size >= 0 and a_size <= a_array.count
			root_valid: a_root >= 0 and a_root < a_size
		local
			l_largest, l_left, l_right: INTEGER
			l_root_key, l_left_key, l_right_key: COMPARABLE
			l_compare: BOOLEAN
		do
			l_largest := a_root
			l_left := 2 * a_root + 1
			l_right := 2 * a_root + 2

			if l_left < a_size then
				l_root_key := a_key.item ([a_array [a_array.lower + l_largest]])
				l_left_key := a_key.item ([a_array [a_array.lower + l_left]])
				if a_descending then
					l_compare := l_left_key < l_root_key
				else
					l_compare := l_left_key > l_root_key
				end
				if l_compare then
					l_largest := l_left
				end
			end

			if l_right < a_size then
				l_root_key := a_key.item ([a_array [a_array.lower + l_largest]])
				l_right_key := a_key.item ([a_array [a_array.lower + l_right]])
				if a_descending then
					l_compare := l_right_key < l_root_key
				else
					l_compare := l_right_key > l_root_key
				end
				if l_compare then
					l_largest := l_right
				end
			end

			if l_largest /= a_root then
				swap (a_array, a_array.lower + a_root, a_array.lower + l_largest)
				heapify (a_array, a_size, l_largest, a_key, a_descending)
			end
		end

	swap (a_array: ARRAY [G]; a_i, a_j: INTEGER)
			-- Swap elements at indices `a_i` and `a_j`.
		require
			i_valid: a_array.valid_index (a_i)
			j_valid: a_array.valid_index (a_j)
		local
			l_temp: G
		do
			l_temp := a_array [a_i]
			a_array [a_i] := a_array [a_j]
			a_array [a_j] := l_temp
		ensure
			swapped_i: a_array [a_i] = old a_array [a_j]
			swapped_j: a_array [a_j] = old a_array [a_i]
			count_unchanged: a_array.count = old a_array.count
		end

end
