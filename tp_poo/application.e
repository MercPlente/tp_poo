note
	description : " "
	author		: "Marc Plante, Insipire by Louis Marchand"
	date        : " "
	revision    : " "

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	IMG_LIBRARY_SHARED		-- To use `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable GAME_ENGINE
		do
			game_library.enable_video -- Enable the video functionalities
			image_file_library.enable_image (true, false, false)
			audio_library.enable_sound
			create l_engine.make
			l_engine.run_game	  -- Run the core creator of the game.
			l_engine := Void
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library  -- Clear the library before quitting
		end


end
