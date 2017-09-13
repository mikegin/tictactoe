note
	description: "{PLAY_AGAIN} class representing a play_again command"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY_AGAIN

inherit
	OPERATION

create{GAME}
	make

feature -- Initialization
	make(g: GAME)
		do
			game := g
			old_status := game.status_string
			old_message := game.message_string
		end

feature -- Attributes
	game: GAME

	old_status: STRING

	old_message: STRING

feature
	execute
		do
			if game.game_finished then -- valid play_again call

				game.set_game_finished (false)

				game.board.clear

				game.clear_history

				-- whoever started second, now starts first
				if game.player2.started_second then
					game.set_current_player (game.player2)

					game.player2.set_started_second (false)
					game.player1.set_started_second (true)
				else
					game.set_current_player (game.player1)

					game.player2.set_started_second (true)
					game.player1.set_started_second (false)
				end

				game.set_status (game.status.ok)
				game.set_message(game.message.next_player (game.current_player.name))
			else
				game.set_status (game.status.finish_this)
			end

		end

	undo
		do
			game.set_status (old_status)
			game.set_message (old_message)
		end

	redo
		do
			execute
		end
end
