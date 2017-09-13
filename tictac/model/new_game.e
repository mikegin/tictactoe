note
	description: "{NEW_GAME} class representing a new_game command"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_GAME

inherit
	OPERATION

create{GAME}
	make

feature -- Initialization
	make(g: GAME; p1_name: STRING; p2_name: STRING)
		do
			game := g
			player1_name := p1_name
			player2_name := p2_name
		end
feature{NONE} -- Attributes
	game: GAME
	player1_name: STRING
	player2_name: STRING

feature
	execute
		do
			if player1_name ~ player2_name then
				game.set_status (game.status.diff_names)

			elseif player1_name.is_empty or player2_name.is_empty or else
					(not player1_name.at (1).is_alpha or not player2_name.at (1).is_alpha) then
				game.set_status (game.status.name_start)

			else
				game.set_players (player1_name, player2_name)

				game.board.clear

				game.clear_history

				game.set_game_finished (false)

				game.set_status (game.status.ok)
				game.set_message (game.message.next_player (game.current_player.name))

			end

		end

	undo
		do

		end

	redo
		do

		end
end
