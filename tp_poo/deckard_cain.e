note
	description: "Classe permettant de creer et gerer deckard_cain"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECKARD_CAIN

inherit
	ENTITY


create
	new_cain

feature {NONE} -- Initialization

	new_cain(a_x:INTEGER;a_y:INTEGER)
			-- Initialization of `Current'
		local
			l_image:IMG_IMAGE_FILE
		do
			set_x(a_x)
			set_y(a_y)
			has_error := False
			create l_image.make ("deckard_cain.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create surface_up.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_right.make_rotate(surface_up, 315, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_right.make_rotate(surface_up, 270, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_right.make_rotate(surface_up, 225, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down.make_rotate(surface_up, 180, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_left.make_rotate(surface_up, 135, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_left.make_rotate(surface_up, 90, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_left.make_rotate(surface_up, 45, True)

					sub_image_width := surface_up.width // 3
					sub_image_height := surface_up.height
				else
					has_error := False
					create surface_up.make(1,1)
					surface_down := surface_up
					surface_right := surface_up
					surface_left := surface_up
					surface_up_right := surface_up
					surface_up_left := surface_up
					surface_down_right := surface_up
					surface_down_left := surface_up
				end
			else
				has_error := False
				create surface_up.make(1,1)
				surface_down := surface_up
				surface_right := surface_up
				surface_left := surface_up
				surface_up_right := surface_up
				surface_up_left := surface_up
				surface_down_right := surface_up
				surface_down_left := surface_up
			end

			surface := surface_up
			initialize_animation_coordinate
		end



	initialize_animation_coordinate
			-- Create the `animation_coordinates'
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface.width // 3, 0])	-- Be sure to place the image standing still first
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface.width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
		end


end
