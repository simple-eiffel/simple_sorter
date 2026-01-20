note
	description: "Merge sort algorithm - O(n log n), stable, uses O(n) extra memory"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_MERGE_SORT [G]

inherit
	SIMPLE_SORT_ALGORITHM [G]

feature -- Access

	name: STRING = "Merge Sort"
			-- <Precursor>

	is_stable: BOOLEAN = True
			-- <Precursor>

	time_complexity: STRING = "O(n log n)"
			-- <Precursor>

	space_complexity: STRING = "O(n)"
			-- <Precursor>

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort `a_array` by `a_key` using merge sort.
		local
			l_temp: ARRAY [G]
		do
			if a_array.count > 1 then
				-- Create temp array by copying original
				create l_temp.make_filled (a_array [a_array.lower], a_array.lower, a_array.upper)
				merge_sort_range (a_array, l_temp, a_array.lower, a_array.upper, a_key, a_descending)
			end
		end

feature {NONE} -- Implementation

	merge_sort_range (a_array: ARRAY [G]; a_temp: ARRAY [G]; a_left, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort range [a_left, a_right] of `a_array`.
		local
			l_mid: INTEGER
		do
			if a_left < a_right then
				l_mid := a_left + (a_right - a_left) // 2
				merge_sort_range (a_array, a_temp, a_left, l_mid, a_key, a_descending)
				merge_sort_range (a_array, a_temp, l_mid + 1, a_right, a_key, a_descending)
				merge (a_array, a_temp, a_left, l_mid, a_right, a_key, a_descending)
			end
		end

	merge (a_array: ARRAY [G]; a_temp: ARRAY [G]; a_left, a_mid, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Merge two sorted halves.
		local
			i, j, k: INTEGER
			l_left_key, l_right_key: COMPARABLE
			l_use_left: BOOLEAN
		do
			-- Copy to temp array
			from
				i := a_left
			until
				i > a_right
			loop
				a_temp [i] := a_array [i]
				i := i + 1
			end

			-- Merge back
			i := a_left
			j := a_mid + 1
			k := a_left

			from
			until
				i > a_mid or j > a_right
			loop
				l_left_key := a_key.item ([a_temp [i]])
				l_right_key := a_key.item ([a_temp [j]])
				if a_descending then
					l_use_left := l_left_key >= l_right_key
				else
					l_use_left := l_left_key <= l_right_key
				end
				if l_use_left then
					a_array [k] := a_temp [i]
					i := i + 1
				else
					a_array [k] := a_temp [j]
					j := j + 1
				end
				k := k + 1
			end

			-- Copy remaining left elements
			from
			until
				i > a_mid
			loop
				a_array [k] := a_temp [i]
				i := i + 1
				k := k + 1
			end

			-- Copy remaining right elements
			from
			until
				j > a_right
			loop
				a_array [k] := a_temp [j]
				j := j + 1
				k := k + 1
			end
		end

end
