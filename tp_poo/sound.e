note
	description: "Summary description for {SOUND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND

inherit
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	GAME_LIBRARY_SHARED		-- To use `game_library'
	EXCEPTIONS

create
	set_sound

create
--	menu_music

--feature {NONE}

--	menu_music (song:STRING)
--		do
--			audio_library.sources_wipe_out
--			create music_loop.make (song)
--			--audio_library.sources
--			music_source:=audio_library.last_source_added
--			if music_loop.is_openable then
--				music_loop.open
--			end
--
--		end


feature {NONE}



	set_sound

		do
			create sound.make ("ding.ogg")			-- This sound will be played when the user press the space bar.
			create music_intro.make ("intro.ogg")		-- This sound will be played once at the begining of the music
			create music_loop.make ("tristram.ogg")		-- This sound will be loop until the application stop.
			create second_music_loop.make ("cath.ogg")											-- The library can use every sound file format that the libsndfile library can use (see: http://www.mega-nerd.com/libsndfile)


			audio_library.sources_add
			music_source:=audio_library.last_source_added
			audio_library.sources_add
			sound_source:=audio_library.last_source_added
			audio_library.sources_add
			second_music_source:=audio_library.last_source_added

			if sound.is_openable and music_intro.is_openable and music_loop.is_openable and second_music_loop.is_openable then
				sound.open
				music_intro.open
				music_loop.open
				second_music_loop.open

			else
				print("Sound files not valid.")
			end

		end

feature

	play_music (menu_current:STRING)
		do
			if music_intro.is_open and music_loop.is_open then
				music_source.stop
				if menu_current.is_equal ("beginning") then
					music_source.queue_sound_infinite_loop (music_intro)
				end
				if menu_current.is_equal ("menu_principal") then
					music_source.queue_sound_infinite_loop (music_loop)
				end
				music_source.play	-- Play the music
			end
		end

	on_iteration_sound(a_time: NATURAL)
			-- Each game loop iteration, update the audio buffers and the `a_window' surface
		do
			audio_library.update
		end

	on_space_key
		do
			sound_source.stop					-- Be sure that the queue buffer is empty on the sound_source object (when stop, the source queue is clear)
			sound.restart						-- Be sure that the sound is at the beginning
			sound_source.queue_sound (sound)	-- Queud the sound into the source queue
			sound_source.play					-- Play the source
		end

	on_a_key
		do
			music_source.stop
			second_music_source.queue_sound_infinite_loop (second_music_loop)
			second_music_source.play
		end


sound:AUDIO_SOUND_FILE
music_intro:AUDIO_SOUND_FILE
music_loop:AUDIO_SOUND_FILE
second_music_loop:AUDIO_SOUND_FILE

sound_source:AUDIO_SOURCE
music_source:AUDIO_SOURCE
second_music_source:AUDIO_SOURCE

end
