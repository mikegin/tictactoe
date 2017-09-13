note
	description: "{STATUS} class that houses the statuses required."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS

create{STATUS_ACCESS}
	make

feature
	make
		do

		end

feature -- Attributes
	ok: STRING = "ok"
	diff_names: STRING = "names of players must be different"
	name_start: STRING = "name must start with A-Z or a-z"
	not_turn: STRING = "not this player's turn"
	not_exist: STRING = "no such player"
	already_taken: STRING = "button already taken"
	winner: STRING = "there is a winner"
	finish_this: STRING = "finish this game first"
	done: STRING = "game is finished"
	tie: STRING = "game ended in a tie"
end
