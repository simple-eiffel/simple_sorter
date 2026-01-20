note
	description: "Insertion sort algorithm - O(n^2), stable, good for small or nearly-sorted data"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_INSERTION_SORT [G]

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
		local
			i, j: INTEGER
			l_current: G
			l_current_key, l_compare_key: COMPARABLE
			l_should_move: BOOLEAN
			l_done: BOOLEAN
		do
			from
				i := a_array.lower + 1
			until
				i > a_array.upper
			loop
				l_current := a_array [i]
				l_current_key := a_key.item ([l_current])
				j := i - 1
				l_done := False
				from
				until
					j < a_array.lower or l_done
				loop
					l_compare_key := a_key.item ([a_array [j]])
					if a_descending then
						l_should_move := l_compare_key < l_current_key
					else
						l_should_move := l_compare_key > l_current_key
					end
					if l_should_move then
						a_array [j + 1] := a_array [j]
						j := j - 1
					else
						l_done := True
					end
				end
				a_array [j + 1] := l_current
				i := i + 1
			end
		end

end
