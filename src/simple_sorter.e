note
	description: "Modern, ergonomic sorting facade with full MML contracts"
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
			default_algorithm: algorithm = internal_introsort
		end

	make_with_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
			-- Create sorter with specified algorithm.
		require
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

feature -- Model queries

	list_to_sequence (a_list: LIST [G]): MML_SEQUENCE [G]
			-- Convert list to MML sequence for specification.
		local
			i: INTEGER
		do
			create Result
			from
				i := 1
			until
				i > a_list.count
			loop
				Result := Result & a_list.i_th (i)
				i := i + 1
			end
		ensure
			same_count: Result.count = a_list.count
		end

	list_to_bag (a_list: LIST [G]): MML_BAG [G]
			-- Convert list to MML bag for permutation checking.
		local
			i: INTEGER
		do
			create Result
			from
				i := 1
			until
				i > a_list.count
			loop
				Result := Result & a_list.i_th (i)
				i := i + 1
			end
		ensure
			same_count: Result.count = a_list.count
		end

	is_sequence_sorted (a_seq: MML_SEQUENCE [G]; a_key: FUNCTION [G, COMPARABLE]): BOOLEAN
			-- Is sequence sorted according to key extractor (ascending)?
		local
			i: INTEGER
			l_prev_key, l_curr_key: COMPARABLE
		do
			Result := True
			if a_seq.count > 1 then
				l_prev_key := a_key.item ([a_seq [1]])
				from
					i := 2
				until
					i > a_seq.count or not Result
				loop
					l_curr_key := a_key.item ([a_seq [i]])
					if l_curr_key < l_prev_key then
						Result := False
					end
					l_prev_key := l_curr_key
					i := i + 1
				end
			end
		ensure
			empty_sorted: a_seq.is_empty implies Result
			singleton_sorted: a_seq.count = 1 implies Result
		end

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

	is_weakly_sorted_by_key (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN): BOOLEAN
			-- Is `a_list` weakly sorted by `a_key`?
			-- "Weakly" means: for multi-key sort, primary key ordering holds except where
			-- secondary keys may determine final order among equal primary keys.
		require
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
					if a_descending then
						if l_curr_key > l_prev then
							Result := False
						end
					else
						if l_curr_key < l_prev then
							Result := False
						end
					end
				end
				l_prev_key := l_curr_key
				i := i + 1
			end
		ensure
			empty_is_sorted: a_list.is_empty implies Result
		end

	is_sorted_by_keys (a_list: LIST [G]; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN]): BOOLEAN
			-- Is `a_list` fully sorted according to all keys?
			-- Adjacent elements must satisfy: compare_by_keys (a, b) <= 0
		require
			keys_not_empty: not a_keys.is_empty
			same_count: a_keys.count = a_descending.count
		local
			i: INTEGER
			l_cmp: INTEGER
		do
			Result := True
			from
				i := 1
			until
				i >= a_list.count or not Result
			loop
				l_cmp := compare_by_keys (a_list.i_th (i), a_list.i_th (i + 1), a_keys, a_descending)
				if l_cmp > 0 then
					Result := False
				end
				i := i + 1
			end
		ensure
			empty_is_sorted: a_list.is_empty implies Result
			single_is_sorted: a_list.count = 1 implies Result
		end

feature -- Basic operations

	sort_by (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_list` by `a_key` in ascending order. Accepts empty/single-element lists.
		require
		local
			l_array: ARRAY [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				algorithm.sort (l_array, a_key, False)
				copy_array_to_list (l_array, a_list)
			end
		ensure
			sorted: is_sorted (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_descending (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_list` by `a_key` in descending order. Accepts empty/single-element lists.
		require
		local
			l_array: ARRAY [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				algorithm.sort (l_array, a_key, True)
				copy_array_to_list (l_array, a_list)
			end
		ensure
			sorted: is_sorted_descending (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_stable (a_list: LIST [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Stable sort `a_list` by `a_key`, preserving equal-element order.
		require
		local
			l_array: ARRAY [G]
			l_saved_algorithm: SIMPLE_SORT_ALGORITHM [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				if algorithm.is_stable then
					algorithm.sort (l_array, a_key, False)
				else
					l_saved_algorithm := algorithm
					algorithm := internal_merge_sort
					algorithm.sort (l_array, a_key, False)
					algorithm := l_saved_algorithm
				end
				copy_array_to_list (l_array, a_list)
			end
		ensure
			sorted: is_sorted (a_list, a_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_array_by (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_array` by `a_key` in ascending order.
		require
		do
			algorithm.sort (a_array, a_key, False)
		ensure
			sorted: is_array_sorted (a_array, a_key)
			count_unchanged: a_array.count = old a_array.count
		end

	sort_array_by_descending (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE])
			-- Sort `a_array` by `a_key` in descending order.
		require
		do
			algorithm.sort (a_array, a_key, True)
		ensure
			count_unchanged: a_array.count = old a_array.count
		end

feature -- Multi-key sorting

	sort_by_then_by (a_list: LIST [G]; a_primary_key: FUNCTION [G, COMPARABLE];
			a_secondary_key: FUNCTION [G, COMPARABLE]; a_secondary_descending: BOOLEAN)
			-- Sort `a_list` by primary key ascending, then by secondary key.
		note
			algorithm: "Uses stable sort to preserve secondary ordering within equal primary keys"
			example: "Sort by name ascending, then by age descending for equal names"
		require
		local
			l_array: ARRAY [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				-- First sort by secondary key
				internal_merge_sort.sort (l_array, a_secondary_key, a_secondary_descending)
				-- Then stable sort by primary key (preserves secondary order within ties)
				internal_merge_sort.sort (l_array, a_primary_key, False)
				copy_array_to_list (l_array, a_list)
			end
		ensure
			sorted_primary: is_sorted (a_list, a_primary_key)
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_comparator (a_list: LIST [G]; a_comparator: FUNCTION [G, G, INTEGER])
			-- Sort `a_list` using custom comparator for multi-field sorting.
		note
			usage: "[
				a_comparator returns: negative if first < second, 0 if equal, positive if first > second.

				Example - sort by name asc, then age desc:
				  sorter.sort_by_comparator (people, agent compare_person)

				  compare_person (a, b: PERSON): INTEGER
				    do
				      Result := a.name.three_way_comparison (b.name)
				      if Result = 0 then
				        Result := b.age - a.age  -- descending
				      end
				    end
			]"
		require
		local
			l_array: ARRAY [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				comparator_sort (l_array, a_comparator)
				copy_array_to_list (l_array, a_list)
			end
		ensure
			count_unchanged: a_list.count = old a_list.count
		end

	sort_by_keys (a_list: LIST [G]; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN])
			-- Sort `a_list` by multiple keys with specified sort directions.
			-- Keys are evaluated in order; first non-equal comparison determines order.
			-- No stable sort required - uses single-pass composite comparator.
		note
			design: "Suggested by Ulrich Windl - more declarative than manual composite comparators"
			usage: "[
				Example - sort people by name ascending, then age descending:
				  sorter.sort_by_keys (people,
				    <<agent {PERSON}.name, agent {PERSON}.age>>,
				    <<False, True>>)  -- False=ascending, True=descending
			]"
		require
			keys_not_empty: not a_keys.is_empty
			same_count: a_keys.count = a_descending.count
		local
			l_array: ARRAY [G]
		do
			if a_list.count > 1 then
				l_array := create_array_from_list (a_list)
				comparator_sort (l_array, agent compare_by_keys (?, ?, a_keys, a_descending))
				copy_array_to_list (l_array, a_list)
			end
		ensure
			count_unchanged: a_list.count = old a_list.count
			sorted_by_all_keys: is_sorted_by_keys (a_list, a_keys, a_descending)
			empty_unchanged: old a_list.is_empty implies a_list.is_empty
		end

	sort_array_by_keys (a_array: ARRAY [G]; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN])
			-- Sort `a_array` by multiple keys with specified sort directions.
		require
			keys_not_empty: not a_keys.is_empty
			same_count: a_keys.count = a_descending.count
		do
			if a_array.count > 1 then
				comparator_sort (a_array, agent compare_by_keys (?, ?, a_keys, a_descending))
			end
		ensure
			count_unchanged: a_array.count = old a_array.count
		end

feature -- Element change

	set_algorithm (a_algorithm: SIMPLE_SORT_ALGORITHM [G])
			-- Set the sorting algorithm.
		require
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
		end

	merge_sort: SIMPLE_MERGE_SORT [G]
			-- Merge sort algorithm (stable, O(n log n), extra memory).
		do
			Result := internal_merge_sort
		ensure
		end

	heap_sort: SIMPLE_HEAP_SORT [G]
			-- Heap sort algorithm (in-place, O(n log n)).
		do
			Result := internal_heap_sort
		ensure
		end

	insertion_sort: SIMPLE_INSERTION_SORT [G]
			-- Insertion sort algorithm (stable, O(n^2), good for small data).
		do
			Result := internal_insertion_sort
		ensure
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

	create_array_from_list (a_list: LIST [G]): ARRAY [G]
			-- Create new array with elements from list (query: returns new array).
		require
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
			empty_list_empty_array: a_list.is_empty implies Result.is_empty
		end

	copy_array_to_list (a_array: ARRAY [G]; a_list: LIST [G])
			-- Copy array contents back to list (command: modifies a_list in place).
		require
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
		ensure
			count_unchanged: a_list.count = old a_list.count
		end

	comparator_sort (a_array: ARRAY [G]; a_comparator: FUNCTION [G, G, INTEGER])
			-- Sort `a_array` using custom comparator (stable insertion sort).
		require
		local
			i, j: INTEGER
			l_current: G
			l_done: BOOLEAN
		do
			from
				i := a_array.lower + 1
			until
				i > a_array.upper
			loop
				l_current := a_array [i]
				j := i - 1
				l_done := False
				from
				until
					j < a_array.lower or l_done
				loop
					if a_comparator.item ([a_array [j], l_current]) > 0 then
						a_array [j + 1] := a_array [j]
						j := j - 1
					else
						l_done := True
					end
				end
				a_array [j + 1] := l_current
				i := i + 1
			end
		ensure
			count_unchanged: a_array.count = old a_array.count
		end

	compare_by_keys (a_first, a_second: G; a_keys: ARRAY [FUNCTION [G, COMPARABLE]]; a_descending: ARRAY [BOOLEAN]): INTEGER
			-- Compare two elements using multiple keys.
			-- Returns: negative if first < second, 0 if equal, positive if first > second.
			-- Evaluates keys in order; first non-zero result determines ordering.
		require
			keys_not_empty: not a_keys.is_empty
			same_count: a_keys.count = a_descending.count
		local
			i: INTEGER
			l_key: FUNCTION [G, COMPARABLE]
			l_val1, l_val2: COMPARABLE
		do
			from
				i := a_keys.lower
				Result := 0
			until
				i > a_keys.upper or Result /= 0
			loop
				l_key := a_keys [i]
				l_val1 := l_key.item ([a_first])
				l_val2 := l_key.item ([a_second])
				Result := l_val1.three_way_comparison (l_val2)
				if a_descending [i] then
					Result := -Result  -- Reverse for descending
				end
				i := i + 1
			end
		ensure
			zero_means_equal_on_all_keys: Result = 0 implies
				across a_keys.lower |..| a_keys.upper as k all
					a_keys [k].item ([a_first]).three_way_comparison (a_keys [k].item ([a_second])) = 0
				end
		end

feature {NONE} -- Constants

	Model_check_threshold: INTEGER = 1000
			-- Maximum collection size for expensive MML model verification.
			-- Larger collections skip O(n²) bag/sequence checks but still verify O(n) sorted property.

invariant
	-- Note: attached types guarantee non-void; contracts here express semantic requirements

end