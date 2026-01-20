note
	description: "Deferred base class for sorting algorithms"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_SORT_ALGORITHM [G]

feature -- Access

	name: STRING
			-- Algorithm name for display.
		deferred
		ensure
			result_exists: Result /= Void
			result_not_empty: not Result.is_empty
		end

	is_stable: BOOLEAN
			-- Does this algorithm preserve order of equal elements?
		deferred
		end

	time_complexity: STRING
			-- Big-O notation for time complexity.
		deferred
		ensure
			result_exists: Result /= Void
		end

	space_complexity: STRING
			-- Big-O notation for space complexity.
		deferred
		ensure
			result_exists: Result /= Void
		end

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort `a_array` by `a_key`.
		require
			array_exists: a_array /= Void
			key_function_exists: a_key /= Void
		deferred
		ensure
			count_unchanged: a_array.count = old a_array.count
		end

end
