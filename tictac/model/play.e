note
	description: "{PLAY} class representing a play command"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAY

inherit
	OPERATION

create{GAME}
	make

feature -- Initialization
	make(g: GAME; p: STRING; pos: TUPLE[i: INTEGER; j: INTEGER])
		do
			game := g
			player_name := p
			position := pos
			create old_status.make_from_string(game.status_string)
			create old_message.make_from_string(game.message_string)
		end

feature{NONE} -- Attributes
	game: GAME
	player_name: STRING
	position: TUPLE[i: INTEGER; j: INTEGER]
	old_status: STRING
	old_message: STRING
	im_valid: BOOLEAN

feature -- Commands
	execute
		do
			old_status := game.status_string
			old_message := game.message_string

			if is_valid_play then
				im_valid := true
				do_execute

				-- check if winning move
					--set game finished to true
					--set status
				if game.check_for_winner then
					game.set_game_finished(true)

					game.current_player.increase_score

					game.clear_history

					game.set_status (game.status.winner)
					game.set_message(game.message.play_again_or_new)

				-- check if tie move
					-- set game finished to true
					-- set status
				 elseif game.check_for_tie then
					game.set_game_finished (true)

					game.clear_history

					game.set_status (game.status.tie)
					game.set_message(game.message.play_again_or_new)

				-- else
					--do execute
					--switch turns
					--set status
				else
					switch_turns

					-- set status
					game.set_status (game.status.ok)
					game.set_message(game.message.next_player (game.current_player.name))

				end
			else
				im_valid := false
				if game.game_finished then
					game.set_status (game.status.done)

				elseif player_name ~ "" or player_name /~ game.player1.name and player_name /~ game.player2.name then
					game.set_status (game.status.not_exist)

				elseif player_name /~ game.current_player.name then
					game.set_status (game.status.not_turn)

				elseif game.board.get (position.i, position.j) /~ game.board.default_char then
					game.set_status (game.status.already_taken)

				end
			end
		end

	undo
		do
			if not game.game_finished then
				if im_valid then
					do_undo
					switch_turns
				end
				game.set_status (old_status)
				game.set_message (old_message)
			end
		end

	redo
		do
			execute
		end

feature{NONE} -- private commands
	do_execute
			-- put the char on the board
		do
			game.board.set (game.current_player.char, position.i, position.j)
		end

	do_undo
		do
			game.board.set (game.board.default_char, position.i, position.j)
		end

	switch_turns
		do
			if game.current_player = game.player1 then
				game.set_current_player(game.player2)
			else
				game.set_current_player(game.player1)
			end
		end

feature{NONE} -- Queries
	is_valid_play: BOOLEAN
			-- checks if it the player's turn is valid and whether the position is open
		do
			Result := player_name /~ "" and player_name ~ game.current_player.name and game.board.get (position.i, position.j) ~ game.board.default_char and game.game_finished = false
		end

end
