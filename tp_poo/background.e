note
	description: "Classe pour aider le contrôle de la camera."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	BACKGROUND

	inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	nouvelle_camera

feature {ANY}

	nouvelle_camera(a_window:GAME_WINDOW_SURFACED)
	-- make pour creer une nouvelle camera avec la surface du jeu
		local
			l_image: IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("background_test.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create game_running_surface.make_from_image (l_image)
				else
					create game_running_surface.make(1,1)
					has_error := True
				end
			else
				create game_running_surface.make(1,1)
				has_error := True
			end
		end

	has_error : BOOLEAN
	-- Bool pour eviter les erreurs

	camera_x, camera_y:INTEGER
	-- Position x et y relative de la camera

	next_background_x:INTEGER assign set_next_background_x
	-- Futur position x de la camera assigner par default par "set_next_background_x"

	next_background_y:INTEGER assign set_next_background_y
	-- Futur position y de la camera assigner par default par "set_next_background_y"

	game_running_surface:GAME_SURFACE
	-- La surface du jeu

	set_next_background_x(a_x:INTEGER)
				-- Assign the value of `next_background_x' with `a_x'
			require
				Is_x_ok: a_x >= 0 or  a_x < 0
			do
				next_background_x := a_x
			ensure
				Is_Assign: next_background_x = a_x
			end

	set_next_background_y(a_y:INTEGER)
				-- Assign the value of `next_background_y' with `a_y'
			require
				Is_y_ok: a_y >= 0 or  a_y < 0
			do
				next_background_y := a_y
			ensure
				Is_Assign: next_background_y = a_y
			end


end
