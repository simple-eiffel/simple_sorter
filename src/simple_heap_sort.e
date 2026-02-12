note
	description: "Heap sort algorithm - O(n log n), in-place, not stable"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_HEAP_SORT [G -> detachable separate ANY]

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
					heapify (a_array, a_array.lower, l_size, i, a_key, a_descending)
					i := i - 1
				end
				-- Extract elements from heap
				from
					i := l_size - 1
				until
					i < 1
				loop
					swap (a_array, a_array.lower, a_array.lower + i)
					heapify (a_array, a_array.lower, i, 0, a_key, a_descending)
					i := i - 1
				end
			end
		ensure then
			stability_not_guaranteed: True -- Heap sort is NOT stable
		end

end
