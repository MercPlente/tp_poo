note
	description: "Classe pour aider le contrôle de la camera."
	author: "Marc Plante,Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	BACKGROUND

	inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	make_background

feature {ANY}

	make_background(a_window:GAME_WINDOW_SURFACED)
	-- constructeur pour creer les fonds d'écran du jeu
		local
			l_image: IMG_IMAGE_FILE
			l_image2: IMG_IMAGE_FILE
			l_image3: IMG_IMAGE_FILE
			l_image4: IMG_IMAGE_FILE
		do
			door_open := False
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

			create l_image2.make ("dungeon_door.png")
			if l_image2.is_openable then
				l_image2.open
				if l_image2.is_open then
					create door.make_from_image (l_image2)
				else
					has_error := True
					create door.make(1,1)
				end
			else
				has_error := True
				create door.make(1,1)
			end

			create l_image3.make ("filtre_dungeon.png")
			if l_image3.is_openable then
				l_image3.open
				if l_image3.is_open then
					create filtre_dungeon.make_from_image (l_image3)
				else
					has_error := True
					create filtre_dungeon.make(1,1)
				end
			else
				has_error := True
				create filtre_dungeon.make(1,1)
			end

			create l_image4.make ("filtre_village.png")
			if l_image4.is_openable then
				l_image4.open
				if l_image4.is_open then
					create filtre_village.make_from_image (l_image4)
				else
					has_error := True
					create filtre_village.make(1,1)
				end
			else
				has_error := True
				create filtre_village.make(1,1)
			end
		end

	has_error : BOOLEAN
	-- Bool pour éviter les erreurs

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
			game_running_surface := nouvelle_surface
		end

	filtre_dungeon: GAME_SURFACE
	-- filtre spooky pour la carte dungeon

	filtre_village: GAME_SURFACE
	-- filtre spooky pour la carte dungeon

	door: GAME_SURFACE
	-- la porte du dungeon

	set_door_open(bool:BOOLEAN)
	-- change le boolean door_open
		do
			door_open := bool
		end

	door_open: BOOLEAN assign set_door_open
	-- si la porte est ouverte

end
