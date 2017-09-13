note
	description: "{PLAYER} class representing a player"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

create{GAME}
	make

feature{NONE} -- Initialization
	make
		do
			create name.make_empty
		end

feature -- Attributes
	name: STRING

	char: CHARACTER

	score: INTEGER

	started_second: BOOLEAN

feature -- Commands
	set_name(n: STRING)
		do
			name := n
		end

	set_char(c: CHARACTER)
		do
			char := c
		end

	set_score(i: INTEGER)
		do
			score := i
		end

	increase_score
		do
			score := score + 1
		end

	set_started_second(b: BOOLEAN)
		do
			started_second := b
		end

end
