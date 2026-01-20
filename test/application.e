note
	description: "Test runner for simple_sorter library"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		local
			l_tests: SIMPLE_SORTER_TESTS
			l_adversarial: ADVERSARIAL_TESTS
		do
			create l_tests
			l_tests.run_all
			print ("%N")
			create l_adversarial
			l_adversarial.run_all
		end

end
