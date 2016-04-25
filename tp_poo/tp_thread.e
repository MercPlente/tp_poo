note
	description: "Classe contenant les threads utilisable par le programme ."
	author: "Marc Plante"
	date: "$2016-04-22$"
	revision: "$Revision$"

class
	TP_THREAD

inherit
	THREAD
	rename
		make as make_thread
	end
create
	make
feature {NONE}
	make (chaine:STRING)
		do
			make_thread
			must_stop:= false
			chaine_utiliser := chaine
		end

feature
	stop_thread
		do
			must_stop := true
		end

feature {NONE}
	execute
		do
			from
			until
				must_stop
			loop
				io.put_string (chaine_utiliser)
				io.output.flush
			end
		end

feature {NONE}
	must_stop: BOOLEAN
	chaine_utiliser:STRING

end
