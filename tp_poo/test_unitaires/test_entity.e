note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_ENTITY

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end
	ABSTRACT_ENTITY
		undefine
			default_create
		end

feature {NONE}

	on_prepare
			-- <Precursor>
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface_width // 3, 0])
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface_width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
		end

	turn_left
		do
		end

	turn_right
		do
		end

	turn_up
		do
		end

	turn_down
		do
		end

	turn_up_right
		do
		end

	turn_down_right
		do
		end

	turn_up_left
		do
		end

	turn_down_left
		do
		end

	surface_width:INTEGER
		do
			Result := 100
		end

	surface_height:INTEGER
		do
			Result := 100
		end

feature -- Test routines

	next_y_test_normal
			-- Test normal de la routine 'set_next_y(a_y:INTEGER)'
		note
			testing:  "execution/serial"
		local
			y_ok:INTEGER
		do
			y_ok:=45
			set_next_y(y_ok)
			assert ("y_test_normal test normal", y_ok ~ next_y)
		end


	next_x_test_normal
			-- Test normal de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_ok:INTEGER
		do
			x_ok:=45
			set_next_x(x_ok)
			assert ("x_test_normal test normal",  x_ok ~ next_x)
		end

	next_y_test_erronee
			-- Test erronee de la routine 'set_next_y(a_y:INTEGER)'
		local
			y_pas_ok:INTEGER
		do
			y_pas_ok:= -74
			set_next_y(y_pas_ok)
			assert ("y_test_limite test limite", y_pas_ok ~ next_y)
		end


	next_x_test_erronee
			-- Test erronee de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_pas_ok:INTEGER
		do
			x_pas_ok:= -74
			set_next_x(x_pas_ok)
			assert ("x_test_limite test limite",  x_pas_ok ~ next_x)
		end

	next_y_test_limite
			-- Test limite de la routine 'set_next_y(a_y:INTEGER)'
		local
			y_limite_ok:INTEGER
		do
			y_limite_ok:= 0
			set_next_y(y_limite_ok)
			assert ("y_test_limite test limite", y_limite_ok ~ next_y)
		end


	next_x_test_limite
			-- Test limite de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_limite_ok:INTEGER
		do
			x_limite_ok:= 0
			set_next_x(x_limite_ok)
			assert ("x_test_limite test limite",  x_limite_ok ~ next_x)
		end

	y_test_normal
			-- Test normal de la routine 'set_next_y(a_y:INTEGER)'
		note
			testing:  "execution/serial"
		local
			y_ok:INTEGER
		do
			y_ok:=45
			set_y(y_ok)
			assert ("y_test_normal test normal", y_ok ~ y)
		end


	x_test_normal
			-- Test normal de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_ok:INTEGER
		do
			x_ok:=45
			set_x(x_ok)
			assert ("x_test_normal test normal",  x_ok ~ x)
		end

	y_test_erronee
			-- Test erronee de la routine 'set_next_y(a_y:INTEGER)'
		local
			y_pas_ok:INTEGER
		do
			y_pas_ok:= -74
			set_y(y_pas_ok)
			assert ("y_test_limite test limite", y_pas_ok ~ y)
		end


	x_test_erronee
			-- Test erronee de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_pas_ok:INTEGER
		do
			x_pas_ok:= -74
			set_x(x_pas_ok)
			assert ("x_test_limite test limite",  x_pas_ok ~ x)
		end

	y_test_limite
			-- Test limite de la routine 'set_next_y(a_y:INTEGER)'
		local
			y_limite_ok:INTEGER
		do
			y_limite_ok:= 0
			set_y(y_limite_ok)
			assert ("y_test_limite test limite", y_limite_ok ~ y)
		end


	x_test_limite
			-- Test limite de la routine 'set_next_x(a_y:INTEGER)'
		local
			x_limite_ok:INTEGER
		do
			x_limite_ok:= 0
			set_x(x_limite_ok)
			assert ("x_test_limite test limite",  x_limite_ok ~ x)
		end


	update_test_normal
		--Test normale de update

		local
			update_timestamp:NATURAL_32
		do
			update_timestamp := 16
			old_timestamp := 0
			going_left:= true
			going_right:= false
			going_up:= true
			going_down:= false
			next_x:= 175
			next_y:= 175
			x := 170
			y := 23


			update(update_timestamp)
			assert ("update_test_normal test normal verifie le x",  x ~ 170)
			assert ("update_test_normal test normal verifie le y", y  ~ (23 - ((update_timestamp - old_timestamp) // movement_delta ).to_integer_32))
			assert ("update_test_normal test normal verifie le old timestamps", old_timestamp   ~ (0 + ((update_timestamp - old_timestamp) // movement_delta) * movement_delta) )


		end

end


