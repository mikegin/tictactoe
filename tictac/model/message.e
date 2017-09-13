note
	description: "{MESSAGE} class that creates the messages required."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE

create{MESSAGE_ACCESS}
	make

feature
	make
		do

		end

feature -- Attributes
	next_player(player: STRING): STRING
		do
			Result := player + " plays next"
		end

	new_game: STRING = "start new game"

	play_again_or_new: STRING = "play again or start new game"
end
