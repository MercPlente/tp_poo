note
	description: "Summary description for {IMAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE

inherit
	GAME_SURFACE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		local
			l_imageBackground: IMG_IMAGE_FILE
		do
			create l_imageBackground.make ("background_resized.jpg")
			if l_imageBackground.is_openable then
				l_imageBackground.open
				if l_imageBackground.is_open then
					make_from_image (l_imageBackground)
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
