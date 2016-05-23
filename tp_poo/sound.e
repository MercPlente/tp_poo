note
	description: "Classe gerant les sons de l'application."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND

inherit
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	EXCEPTIONS

create
	set_sound


feature {ANY}


	set_sound
	-- Fonction creant les sources et les audio sound file / ouvre les pistes a jouer

		do
			create sound.make ("ding.ogg")
			create music_intro.make ("intro.ogg")
			create music_loop.make ("tristram.ogg")
			create second_music_loop.make ("cath.ogg")


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
		ensure
			Sound_Ouvert:sound.is_open
			Music_Ouvert:music_intro.is_open
			Music_Loop_Ouvert:music_loop.is_open
			Second_Musique_Loop_Ouvert:second_music_loop.is_open

		end

feature

	play_music (song_name:STRING)
	--Change la musique en loop selon le menu
		do
			if music_intro.is_open and music_loop.is_open then
				music_source.stop
				if song_name.is_equal ("beginning") then
					music_source.queue_sound_infinite_loop (music_intro)
				end
				if song_name.is_equal ("tristram") then
					music_source.queue_sound_infinite_loop (music_loop)
				end
				if song_name.is_equal ("dungeon") then
					music_source.queue_sound_infinite_loop (second_music_loop)
				end
				music_source.play	-- Play the music
			end
		end

	on_iteration_sound(a_time: NATURAL)
			-- Evenement qui met a jour la librairie de son a chaque iteration
		do
			audio_library.update
		end

	on_space_key
	-- Fonction qui vide le buffer, met un son au debut de la source et la fait jouer.
		do
			sound_source.stop
			sound.restart
			sound_source.queue_sound (sound)
			sound_source.play
		ensure
			Source_Ouvert:sound_source.is_playing
		end

	on_a_key
		-- Arrete la source de musique principal et demarre la deuxieme
		do
			music_source.stop
			second_music_source.queue_sound_infinite_loop (second_music_loop)
			second_music_source.play
		ensure
			Source_Ouvert:second_music_source.is_playing
		end


sound:AUDIO_SOUND_FILE
music_intro:AUDIO_SOUND_FILE
music_loop:AUDIO_SOUND_FILE
second_music_loop:AUDIO_SOUND_FILE

sound_source:AUDIO_SOURCE
music_source:AUDIO_SOURCE
second_music_source:AUDIO_SOURCE

end

