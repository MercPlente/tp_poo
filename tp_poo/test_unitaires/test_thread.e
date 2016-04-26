note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_THREAD

inherit
	EQA_TEST_SET
	TP_THREAD
		undefine
			default_create
		end

feature -- Test routines

	test_make_normal
			-- Test normal du construteur de TP_THREAD  'make(chaine:STRING)'
		do
			make ("string")
			assert ("not_implemented", False)
		end

end


