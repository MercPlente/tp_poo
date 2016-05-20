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
	make_background

feature {ANY}

	make_background(a_window:GAME_WINDOW_SURFACED)
	-- make pour creer une nouvelle camera avec la surface du jeu
		local
			l_image: IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("village.png")
			current_map := "village"
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

	current_map: STRING assign set_map_string
	-- Le nom de la carte actuelle

	set_map_string(nouvelle_carte: STRING)
	-- change le string current_map
		do
			current_map := nouvelle_carte
		end

	game_running_surface:GAME_SURFACE assign set_running_surface
	-- La surface du jeu

	set_running_surface(nouvelle_surface:GAME_SURFACE)
	-- change la surface du jeu
		do
			print("changing surface%N")
			game_running_surface := nouvelle_surface
		end

end
