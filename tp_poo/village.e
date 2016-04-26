note
	description: "Classe qui gère la région 'village'."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VILLAGE

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	GAME_SURFACE
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	new_village

feature {NONE}

	new_village
		-- Fonction qui recommence les iterations avec les nouvelles valeurs pour cette région.
		local
			l_image: IMG_IMAGE_FILE
		do
			create l_image.make ("background_test.png")
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
		end


end
