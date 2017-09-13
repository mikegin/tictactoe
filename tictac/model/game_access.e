note
	description: "Singleton access to the game model."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GAME_ACCESS

feature
	m: GAME
		once
			create Result.make
		end

invariant
	m = m
end




