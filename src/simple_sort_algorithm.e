note
	description: "Deferred base class for sorting algorithms with full MML contracts"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE_SORT_ALGORITHM [G -> detachable separate ANY]

feature -- Access

	name: STRING
			-- Algorithm name for display.
		deferred
		ensure
			result_not_empty: not Result.is_empty
		end

	is_stable: BOOLEAN
			-- Does this algorithm preserve order of equal elements?
		deferred
		end

	time_complexity: STRING
			-- Big-O time complexity.
		deferred
		ensure
			result_not_empty: not Result.is_empty
		end

	space_complexity: STRING
			-- Big-O space complexity.
		deferred
		ensure
			result_not_empty: not Result.is_empty
		end

feature -- Model queries

	array_to_sequence (a_array: ARRAY [G]): MML_SEQUENCE [G]
			-- Convert array to MML sequence for specification.
		local
			i: INTEGER
		do
			create Result
			from
				i := a_array.lower
			until
				i > a_array.upper
			loop
				Result := Result & a_array [i]
				i := i + 1
			end
		ensure
			same_count: Result.count = a_array.count
		end

	array_to_bag (a_array: ARRAY [G]): MML_BAG [G]
			-- Convert array to MML bag for permutation checking.
		local
			i: INTEGER
		do
			create Result
			from
				i := a_array.lower
			until
				i > a_array.upper
			loop
				Result := Result & a_array [i]
				i := i + 1
			end
		ensure
			same_count: Result.count = a_array.count
		end

	is_sequence_sorted (a_seq: MML_SEQUENCE [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN): BOOLEAN
			-- Is sequence sorted according to key extractor?
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
					if a_descending then
						if l_curr_key > l_prev_key then
							Result := False
						end
					else
						if l_curr_key < l_prev_key then
							Result := False
						end
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

	is_sorted (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN): BOOLEAN
			-- Is array sorted by key in specified order?
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
					if a_descending then
						if l_curr_key > l_prev_key then
							Result := False
						end
					else
						if l_curr_key < l_prev_key then
							Result := False
						end
					end
					l_prev_key := l_curr_key
					i := i + 1
				end
			end
		ensure
			empty_sorted: a_array.is_empty implies Result
			singleton_sorted: a_array.count = 1 implies Result
		end

	is_permutation (a_array, a_original: ARRAY [G]): BOOLEAN
			-- Does array contain same elements as original?
		note
			semantics: "Permutation check using MML_BAG for mathematical precision"
		do
			Result := array_to_bag (a_array) |=| array_to_bag (a_original)
		ensure
			same_count: Result implies a_array.count = a_original.count
		end

feature -- Basic operations

	sort (a_array: ARRAY [G]; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Sort array by key. Empty and single-element arrays are trivially sorted.
		deferred
		ensure
			count_unchanged: a_array.count = old a_array.count
			result_sorted: is_sorted (a_array, a_key, a_descending)
			result_permutation: is_permutation (a_array, old a_array.twin)
			model_sorted: is_sequence_sorted (array_to_sequence (a_array), a_key, a_descending)
			model_permutation: array_to_bag (a_array) |=| old array_to_bag (a_array.twin)
		end

feature {NONE} -- Implementation helpers

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

	heapify (a_array: ARRAY [G]; a_base, a_size, a_root: INTEGER;
			a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Maintain heap property for subtree rooted at `a_root` with base offset `a_base`.
		require
			size_valid: a_size >= 0 and a_size <= a_array.count
			root_valid: a_root >= 0 and a_root < a_size
			base_valid: a_array.valid_index (a_base)
		local
			l_largest, l_left, l_right: INTEGER
			l_root_key, l_left_key, l_right_key: COMPARABLE
			l_compare: BOOLEAN
		do
			l_largest := a_root
			l_left := 2 * a_root + 1
			l_right := 2 * a_root + 2
			if l_left < a_size then
				l_root_key := a_key.item ([a_array [a_base + l_largest]])
				l_left_key := a_key.item ([a_array [a_base + l_left]])
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
				l_root_key := a_key.item ([a_array [a_base + l_largest]])
				l_right_key := a_key.item ([a_array [a_base + l_right]])
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
				swap (a_array, a_base + a_root, a_base + l_largest)
				heapify (a_array, a_base, a_size, l_largest, a_key, a_descending)
			end
		end

	insertion_sort_range (a_array: ARRAY [G]; a_left, a_right: INTEGER; a_key: FUNCTION [G, COMPARABLE]; a_descending: BOOLEAN)
			-- Insertion sort elements in range [a_left, a_right].
		require
			left_valid: a_array.valid_index (a_left)
			right_valid: a_array.valid_index (a_right)
		local
			i, j: INTEGER
			l_current: G
			l_current_key, l_compare_key: COMPARABLE
			l_should_move: BOOLEAN
			l_done: BOOLEAN
		do
			from
				i := a_left + 1
			until
				i > a_right
			loop
				l_current := a_array [i]
				l_current_key := a_key.item ([l_current])
				j := i - 1
				l_done := False
				from
				until
					j < a_left or l_done
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