note
	description: "Classe permettant de gerer le personnage du joueur dans l'application. Grandement inspirée de la classe 'Maryo' de Louis"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	ENTITY


create
	new_player

feature {NONE} -- Initialization

	new_player
			-- Initialization of `Current'
		local
			l_image:IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("personnage.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create right_surface.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} left_surface.make_zoom_x_y (right_surface, -1, 1, False)
					sub_image_width := right_surface.width // 3
					sub_image_height := right_surface.height
				else
					has_error := False
					create right_surface.make(1,1)
					left_surface := right_surface
				end
			else
				has_error := False
				create right_surface.make(1,1)
				left_surface := right_surface
			end
			surface := right_surface
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
