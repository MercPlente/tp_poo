note
	description: "Identifie si un object est selectionn�."
	author: "Marc Plante, J�r�mie Daem"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SELECTABLE


feature

	make_selection
	-- make de SELECTABLE
		do
			is_selected := false
		end

	is_selected: BOOLEAN assign set_is_selected
	-- V�rifie si cain est selectionn�

	set_is_selected(bool:BOOLEAN)
	-- Change is_selected
	do
		is_selected := bool
	end


end


