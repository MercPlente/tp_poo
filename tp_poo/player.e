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
			l_image2:IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("kenny.png")
			create l_image2.make ("kenny_rotated.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create surface_up.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down.make_rotate(surface_up, 180, True)

					sub_image_width := surface_up.width // 3
					sub_image_height := surface_up.height
				else
					has_error := False
					create surface_up.make(1,1)
					surface_down := surface_up
				end
			else
				has_error := False
				create surface_up.make(1,1)
				surface_down := surface_up
			end
			if l_image2.is_openable then
				l_image2.open
				if l_image2.is_open then
					create surface_right.make_from_image (l_image2)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_left.make_rotate(surface_right, 180, True)
				else
					has_error := False
					create surface_right.make(1,1)
					surface_left := surface_right
				end
			else
				has_error := False
				create surface_right.make(1,1)
				surface_left := surface_right

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
