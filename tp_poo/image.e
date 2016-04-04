note
	description: "Classe gerant les images du programmes."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE

inherit
	GAME_SURFACE
		rename
			make as make_surface
		end

create
	make

feature {NONE} -- Initialisation

	make (background:STRING)
	-- Fonction modifiant le fond d'ecran.
		local
			l_imageBackground: IMG_IMAGE_FILE
		do
			create l_imageBackground.make (background)
			if l_imageBackground.is_openable then
				l_imageBackground.open
				if l_imageBackground.is_open then
					make_from_image (l_imageBackground)
				else
					has_error := True
					make_surface(1,1)
				end
			else
				has_error := True
				make_surface(1,1)
			end
		end

end
