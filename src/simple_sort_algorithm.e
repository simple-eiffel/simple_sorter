note
	description: "Deferred base class for sorting algorithms with full MML contracts"
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
			result_not_empty: not Result.is_empty
		end

	is_stable: BOOLEAN
			-- Does this algorithm preserve order of equal elements?
		deferred
		end

	time_complexity: STRING
			-- Big-O time complexity.
		deferred
		end

	space_complexity: STRING
			-- Big-O space complexity.
		deferred
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

end