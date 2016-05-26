note
	description: "Classe de creation des leviers."
	author: "Marc Plante, Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	LEVER


	inherit
	SELECTABLE
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	make_levier


feature

	make_levier(a_x:INTEGER;a_y:INTEGER)
	-- make pour créer les nouveaux leviers

	local
		levier_ouvert_img : IMG_IMAGE_FILE
		levier_fermer_img : IMG_IMAGE_FILE
		levier_ouvert_img_s : IMG_IMAGE_FILE
		levier_fermer_img_s : IMG_IMAGE_FILE
	do
		set_x(a_x)
		set_y(a_y)
		levier_ouvert := false
		has_error := false
		make_selection
		create levier_ouvert_img.make ("levier_ouvert.png")
		if levier_ouvert_img.is_openable then
			levier_ouvert_img.open
			if levier_ouvert_img.is_open then
				create surface_levier_ouvert.make_from_image (levier_ouvert_img)
			else
				create surface_levier_ouvert.make(1,1)
				has_error := True
			end
		else
			create surface_levier_ouvert.make(1,1)
			has_error := True
		end

		create levier_fermer_img.make ("levier_fermer.png")
		if levier_fermer_img.is_openable then
			levier_fermer_img.open
			if levier_fermer_img.is_open then
				create surface_levier_fermer.make_from_image (levier_fermer_img)
			else
				has_error := True
				create surface_levier_fermer.make(1,1)
			end
		else
			has_error := True
			create surface_levier_fermer.make(1,1)
		end

		create levier_ouvert_img_s.make ("levier_ouvert_s.png")
		if levier_ouvert_img_s.is_openable then
			levier_ouvert_img_s.open
			if levier_ouvert_img_s.is_open then
				create surface_levier_selectionner_ouvert.make_from_image (levier_ouvert_img)
			else
				create surface_levier_selectionner_ouvert.make(1,1)
				has_error := True
			end
		else
			create surface_levier_selectionner_ouvert.make(1,1)
			has_error := True
		end

		create levier_fermer_img_s.make ("levier_fermer_s.png")
		if levier_fermer_img_s.is_openable then
			levier_fermer_img_s.open
			if levier_fermer_img_s.is_open then
				create surface_levier_selectionner_fermer.make_from_image (levier_fermer_img_s)
			else
				has_error := True
				create surface_levier_selectionner_fermer.make(1,1)
			end
		else
			has_error := True
			create surface_levier_selectionner_fermer.make(1,1)
		end

		lever_running_surface := surface_levier_fermer
	end


	set_x(a_x:INTEGER)
			-- Assigne la valeur de `x' avec `a_x'
		require
			correct : a_x >= 0
		do
			x := a_x
		ensure
			Is_ok: a_x >= 0
			Is_Assign: x = a_x
		end

	set_y(a_y:INTEGER)
			-- Assigne la valeur de `y' avec `a_y'
		require
			correct : a_y >= 0
		do
			y := a_y
		ensure
			Is_ok: y >= 0
			Is_Assign: y = a_y
		end

	x:INTEGER assign set_x
			-- Position horizontale de `Current'

	y:INTEGER assign set_y
			-- Position verticale de `Current'

	has_error : BOOLEAN
	-- Bool pour éviter les erreurs

	levier_ouvert : BOOLEAN assign set_levier_ouvert
	-- Boolean pour savoir si le levier est ouvert ou non

	set_levier_ouvert(bool: BOOLEAN)
	-- changer levier_ouvert
	do
		levier_ouvert := bool
	end

	surface_levier_ouvert : GAME_SURFACE
	--surface du levier ouvert

	surface_levier_fermer : GAME_SURFACE
	--surface du levier fermer

	surface_levier_selectionner_ouvert : GAME_SURFACE
	--surface du levier ouvert

	surface_levier_selectionner_fermer : GAME_SURFACE
	--surface du levier fermer



	lever_running_surface:GAME_SURFACE assign set_lever_running_surface
	-- La surface du jeu

	set_lever_running_surface(nouvelle_surface:GAME_SURFACE)
	-- change la surface du jeu
		do
			lever_running_surface := nouvelle_surface
		end

end
