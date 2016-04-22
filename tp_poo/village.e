note
	description: "Classe qui gère la région 'village'."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VILLAGE

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	new_village

feature {NONE}

	new_village (a_sound:SOUND; a_window:GAME_WINDOW_SURFACED)
		-- Fonction qui recommence les iterations avec les nouvelles valeurs pour cette région.
		local
			l_image:IMAGE
			--l_player:PLAYER

		do
			game_library.clear_all_events
			create l_image.make ("village.png")
			l_image.change_background("village.png",a_window)
			sounds := a_sound
		end

	sounds:SOUND

end
