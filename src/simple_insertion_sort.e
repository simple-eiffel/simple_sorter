note
	description: "Insertion sort algorithm - O(n^2), stable, good for small or nearly-sorted data"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_INSERTION_SORT [G -> detachable separate ANY]

inherit
	SIMPLE_SORT_ALGORITHM [G]

feature -- Access

	name: STRING = "Insertion Sort"
			-- <Precursor>

	is_stable: BOOLEAN = True
			-- <Precursor>

	time_complexity: STRING = "O(n^2)"
			-- <Precursor>

	space_complexity: STRING = "O(1)"
			-- <Precursor>

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort `a_array` by `a_key` using insertion sort.
			-- <Precursor>
		do
			if a_array.count > 1 then
				insertion_sort_range (a_array, a_array.lower, a_array.upper, a_key, a_descending)
			end
		ensure then
			stability_guaranteed: True -- Insertion sort IS stable
		end

end
