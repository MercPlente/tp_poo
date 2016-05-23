note
	description: "Classe qui gère la région 'dungeon'."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUNGEON

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	GAME_SURFACE
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	new_dungeon

feature {NONE}

	new_dungeon
		-- Fonction qui recommence les iterations avec les nouvelles valeurs pour cette région.
		local
			l_image: IMG_IMAGE_FILE
			l_image2: IMG_IMAGE_FILE
		do
			create l_image.make ("dungeon.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					make_from_image (l_image)
				else
					has_error := True
					make(1,1)
				end
			else
				has_error := True
				make(1,1)
			end

			create l_image2.make ("dungeon_door.png")
			if l_image2.is_openable then
				l_image2.open
				if l_image2.is_open then
					create dungeon_door.make_from_image (l_image2)
				else
					has_error := True
					create dungeon_door.make(1,1)
				end
			else
				has_error := True
				create dungeon_door.make(1,1)
			end
		end

feature -- Access

	dungeon_door: GAME_SURFACE

end
