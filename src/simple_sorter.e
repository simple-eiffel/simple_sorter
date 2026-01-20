note
	description: "Modern, ergonomic sorting facade with agent-based comparison"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_SORTER [G]

create
	make,
	make_with_algorithm

feature {NONE} -- Initialization

	make
			-- Create sorter with default algorithm (introsort).
		do
			create internal_introsort
			create internal_merge_sort
			create internal_heap_sort
			create internal_insertion_sort
			algorithm := internal_introsort
		ensure
			algorithm_set: algorithm /= Void
			default_algorithm: algorithm = internal_introsort
		end

	make_with_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
			-- Create sorter with specified algorithm.
		require
			algorithm_exists: a_algorithm /= Void
		do
			create internal_introsort
			create internal_merge_sort
			create internal_heap_sort
			create internal_insertion_sort
			algorithm := a_algorithm
		ensure
			algorithm_set: algorithm = a_algorithm
		end

feature -- Access

	algorithm: SIMPLE_SORT_ALGORITHM [G]
			-- Current sorting algorithm.

feature -- Status report

	is_introsort: BOOLEAN
			-- Is current algorithm introsort?
		do
			Result := algorithm = internal_introsort
		end

	is_stable: BOOLEAN
			-- Does current algorithm preserve equal-element order?
		do
			Result := algorithm.is_stable
		end

	is_sorted (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
			-- Is `a_list` sorted by `a_key` in ascending order?
		require
			list_exists: a_list /= Void
			key_function_exists: a_key /= Void
		local
			l_prev_key: detachable COMPARABLE
			l_curr_key: COMPARABLE
			i: INTEGER
		do
			Result := True
			from
				i := 1
			until
				i > a_list.count or not Result
			loop
				l_curr_key := a_key.item ([a_list.i_th (i)])
				if attached l_prev_key as l_prev then
					if l_curr_key < l_prev then
						Result := False
					end
				end
				l_prev_key := l_curr_key
				i := i + 1
			end
		ensure
			empty_is_sorted: a_list.is_empty implies Result
		end

	is_sorted_descending (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
			-- Is `a_list` sorted by `a_key` in descending order?
		require
			list_exists: a_list /= Void
			key_function_exists: a_key /= Void
		local
			l_prev_key: detachable COMPARABLE
			l_curr_key: COMPARABLE
			i: INTEGER
		do
			Result := True
			from
				i := 1
			until
				i > a_list.count or not Result
			loop
				l_curr_key := a_key.item ([a_list.i_th (i)])
				if attached l_prev_key as l_prev then
					if l_curr_key > l_prev then
						Result := False
					end
				end
				l_prev_key := l_curr_key
				i := i + 1
			end
		ensure
			empty_is_sorted: a_list.is_empty implies Result
		end

	is_array_sorted (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
			-- Is `a_array` sorted by `a_key` in ascending order?
		require
			array_exists: a_array /= Void
			key_function_exists: a_key /= Void
		local
			i: INTEGER
			l_prev_key, l_curr_key: COMPARABLE
		do
			Result := True
			if a_array.count > 1 then
				l_prev_key := a_key.item ([a_array [a_array.lower]])
				from
					i := a_array.lower + 1
				until
					i > a_array.upper or not Result
				loop
					l_curr_key := a_key.item ([a_array [i]])
					if l_curr_key < l_prev_key then
						Result := False
					end
					l_prev_key := l_curr_key
					i := i + 1
				end
			end
		ensure
			empty_is_sorted: a_array.is_empty implies Result
		end

feature -- Basic operations

	sort_by (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_list` by `a_key` in ascending order.
		require
			list_exists: a_list /= Void
			key_function_exists: a_key /= Void
			list_not_empty: not a_list.is_empty
		local
			l_array: ARRAY [G]
		do
			l_array := list_to_array (a_list)
			algorithm.sort (l_array, a_key, False)
			array_to_list (l_array, a_list)
		ensure
			sorted: is_sorted (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_descending (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_list` by `a_key` in descending order.
		require
			list_exists: a_list /= Void
			key_function_exists: a_key /= Void
			list_not_empty: not a_list.is_empty
		local
			l_array: ARRAY [G]
		do
			l_array := list_to_array (a_list)
			algorithm.sort (l_array, a_key, True)
			array_to_list (l_array, a_list)
		ensure
			sorted: is_sorted_descending (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_stable (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Stable sort `a_list` by `a_key` (preserves equal-element order).
		require
			list_exists: a_list /= Void
			key_function_exists: a_key /= Void
			list_not_empty: not a_list.is_empty
		local
			l_array: ARRAY [G]
			l_saved_algorithm: SIMPLE_SORT_ALGORITHM [G]
		do
			l_array := list_to_array (a_list)
			if algorithm.is_stable then
				algorithm.sort (l_array, a_key, False)
			else
				l_saved_algorithm := algorithm
				algorithm := internal_merge_sort
				algorithm.sort (l_array, a_key, False)
				algorithm := l_saved_algorithm
			end
			array_to_list (l_array, a_list)
		ensure
			sorted: is_sorted (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_array_by (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_array` by `a_key` in ascending order.
		require
			array_exists: a_array /= Void
			key_function_exists: a_key /= Void
		do
			algorithm.sort (a_array, a_key, False)
		ensure
			sorted: is_array_sorted (a_array, a_key)
			count_unchanged: a_array.count = old a_array.count
		end

	sort_array_by_descending (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_array` by `a_key` in descending order.
		require
			array_exists: a_array /= Void
			key_function_exists: a_key /= Void
		do
			algorithm.sort (a_array, a_key, True)
		ensure
			count_unchanged: a_array.count = old a_array.count
		end

feature -- Element change

	set_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
			-- Set the sorting algorithm.
		require
			algorithm_exists: a_algorithm /= Void
		do
			algorithm := a_algorithm
		ensure
			algorithm_set: algorithm = a_algorithm
		end

feature -- Algorithm access

	introsort: SIMPLE_INTROSORT [G]
			-- Introsort algorithm (hybrid quick/heap/insertion).
		do
			Result := internal_introsort
		ensure
			result_exists: Result /= Void
		end

	merge_sort: SIMPLE_MERGE_SORT [G]
			-- Merge sort algorithm (stable, O(n log n), extra memory).
		do
			Result := internal_merge_sort
		ensure
			result_exists: Result /= Void
		end

	heap_sort: SIMPLE_HEAP_SORT [G]
			-- Heap sort algorithm (in-place, O(n log n)).
		do
			Result := internal_heap_sort
		ensure
			result_exists: Result /= Void
		end

	insertion_sort: SIMPLE_INSERTION_SORT [G]
			-- Insertion sort algorithm (stable, O(n^2), good for small data).
		do
			Result := internal_insertion_sort
		ensure
			result_exists: Result /= Void
		end

feature {NONE} -- Implementation

	internal_introsort: SIMPLE_INTROSORT [G]
			-- Cached introsort instance.

	internal_merge_sort: SIMPLE_MERGE_SORT [G]
			-- Cached merge sort instance.

	internal_heap_sort: SIMPLE_HEAP_SORT [G]
			-- Cached heap sort instance.

	internal_insertion_sort: SIMPLE_INSERTION_SORT [G]
			-- Cached insertion sort instance.

	list_to_array (a_list: LIST [G]): ARRAY [G]
			-- Convert list to array for sorting.
		require
			list_exists: a_list /= Void
			list_not_empty: not a_list.is_empty
		local
			i: INTEGER
		do
			create Result.make_empty
			from
				a_list.start
				i := 1
			until
				a_list.after
			loop
				Result.force (a_list.item, i)
				a_list.forth
				i := i + 1
			end
		ensure
			same_count: Result.count = a_list.count
		end

	array_to_list (a_array: ARRAY [G]; a_list: LIST [G])
			-- Copy array contents back to list.
		require
			array_exists: a_array /= Void
			list_exists: a_list /= Void
			same_count: a_array.count = a_list.count
		local
			i: INTEGER
		do
			from
				a_list.start
				i := a_array.lower
			until
				a_list.after
			loop
				a_list.replace (a_array [i])
				a_list.forth
				i := i + 1
			end
		end

invariant
	algorithm_exists: algorithm /= Void
	introsort_exists: internal_introsort /= Void
	merge_sort_exists: internal_merge_sort /= Void
	heap_sort_exists: internal_heap_sort /= Void
	insertion_sort_exists: internal_insertion_sort /= Void

end
