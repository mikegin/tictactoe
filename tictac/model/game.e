note
	description: "The Game class representing the main logic of the tic-tac-toe game."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ANY
		redefine
			out
		end

create {GAME_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		local
			status_access: STATUS_ACCESS
			message_access: MESSAGE_ACCESS
		do
			-- set the players and board
			create op_list.make

			create board.make(3, 3)

			create player1.make
			player1.set_char ('X')
			create player2.make
			player2.set_char('O')

			current_player := player1

			-- set status and message strings
			status := status_access.m
			message := message_access.m
			create status_string.make_from_string(status.ok)
			create message_string.make_from_string(message.new_game)
		end

feature{GAME, STUDENT_TESTS} -- model attributes
	-- list of operations executd by the user(s)
	op_list: TWO_WAY_LIST[OPERATION]

feature{GAME, OPERATION, STUDENT_TESTS} -- Attributes
	board: BOARD

	player1: PLAYER

	player2: PLAYER

	current_player: PLAYER

	status_string: STRING

	message_string: STRING

	status: STATUS

	message: MESSAGE

	game_finished: BOOLEAN

	test_i: INTEGER

feature{OPERATION} -- Commands
	set_players(p1: STRING; p2: STRING)
		do
			player1.set_name (p1)
			player2.set_name (p2)
			player1.set_score (0)
			player2.set_score (0)
			set_current_player (player1)
			player2.set_started_second (true)
		end

	set_current_player(p: PLAYER)
		do
			current_player := p
		end

	set_status(s: STRING)
		do
			status_string := s
		end

	set_message(m: STRING)
		do
			message_string := m
		end

	set_game_finished(b: BOOLEAN)
		do
			game_finished := b
		end

	clear_history
		local
			new_list: TWO_WAY_LIST[OPERATION]
		do
			create new_list.make
			op_list := new_list
		ensure
			op_list.is_empty
		end

feature -- Commands
	reset
			-- Reset model state.
		do
			make
		end

	new_game(p1: STRING; p2: STRING)
			-- Create a new game.
		local
			n: NEW_GAME
		do
			create n.make(Current, p1, p2)
			n.execute
		end

	play(player: STRING; pos: INTEGER)
			-- Execute a play command.
		local
			p: PLAY
		do
			if op_list.index < op_list.count then
				--remove all items to the right
				remove_all_right
			end
			create p.make(Current, player, int_to_board_coordinates(pos))
			op_list.force (p)
			if op_list.index /= op_list.count then
				op_list.forth
			end
			p.execute
		end

	play_again
			-- Restart the game.
		local
			pa: PLAY_AGAIN
		do
			if op_list.index < op_list.count then
				--remove all items to the right
				remove_all_right
			end
			create pa.make(Current)
			op_list.force (pa)
			if op_list.index /= op_list.count then
				op_list.forth
			end
			pa.execute
		end

	undo
			-- Undo the last operation.
		local
			op: OPERATION
		do
			if not op_list.is_empty and not op_list.before then
				op := op_list.item
				op.undo
				op_list.back
			end
		end

	redo
			-- Redo the last operation.
		local
			op: OPERATION
		do
			if not op_list.is_empty and op_list.index < op_list.count then
				op_list.forth
				op := op_list.item
				op.redo
			end
		end

feature{NONE} -- Commands
	remove_all_right
		require
			op_list.index < op_list.count
		do
			op_list.forth
			from

			until
				op_list.after
			loop
				op_list.remove
			end
			op_list.back
		end

feature -- Queries
	out : STRING
		do
			--test_i := test_i + 1
			create Result.make_empty
			--Result := Result + test_i.out
			Result := Result + "  " + status_string + ":"
			--Result := Result + op_list.index.out
			if message_string ~ message.new_game then
				Result := Result + " "
			end
			Result := Result + " => " + message_string
			Result := Result + "%N"
			Result := Result + board.out
			Result := Result + "%N"
			Result := Result +  "  " + player1.score.out + ": score for %"" + player1.name + "%" (as " + player1.char.out + ")"
			Result := Result + "%N"
			Result := Result +  "  " + player2.score.out + ": score for %"" + player2.name + "%" (as " + player2.char.out + ")"
		end

feature{GAME, OPERATION, STUDENT_TESTS} -- Queries
	board_height: INTEGER
		do
			Result := board.board_height
		end

	check_for_tie: BOOLEAN
			-- Checks for a tie
		do
			Result := board.board_is_full and not check_for_winner
		end

	check_for_winner: BOOLEAN
			-- Checks if c is a winning character
		local
			i: INTEGER
			j: INTEGER
			count1: INTEGER
			count2: INTEGER
			flag: BOOLEAN
		do
			-- Check winner in rows
			from
				i := 1
			until
				flag or else i > board.board_height
			loop
				from
					j := 1
				until
					j > board.board_width
				loop
					if board.get (i, j) ~ player1.char then
						count1 := count1 + 1
					elseif board.get (i, j) ~ player2.char then
						count2 := count2 + 1
					end
					j := j + 1
				end
				if count1 = 3 or count2 = 3 then
					flag := true
				end
				count1 := 0
				count2 := 0
				i := i + 1
			end

			-- Check winner in coloumns
			if not flag then -- no winner found thus far
				from
					i := 1
				until
					flag or else i > board.board_width
				loop
					from
						j := 1
					until
						j > board.board_height
					loop
						if board.get (j, i) ~ player1.char then
						count1 := count1 + 1
					elseif board.get (j, i) ~ player2.char then
						count2 := count2 + 1
					end
					j := j + 1
				end
				if count1 = 3 or count2 = 3 then
					flag := true
				end
				count1 := 0
				count2 := 0
					i := i + 1
				end
			end

			-- Check \ diagonal
			if not flag then
				from
					i := 1
					j := 1
				until
					i > board.board_height
				loop
					if board.get (i, j) ~ player1.char then
						count1 := count1 + 1
					elseif board.get (i, j) ~ player2.char then
						count2 := count2 + 1
					end
					if count1 = 3 or count2 = 3 then
						flag := true
					end
					i := i + 1
					j := j + 1
				end
				count1 := 0
				count2 := 0
			end

			-- Check / diagonal
			if not flag then
				from
					i := 1
					j := board.board_width
				until
					i > board.board_height
				loop
					if board.get (i, j) ~ player1.char then
						count1 := count1 + 1
					elseif board.get (i, j) ~ player2.char then
						count2 := count2 + 1
					end
					if count1 = 3 or count2 = 3 then
						flag := true
					end
					i := i + 1
					j := j - 1
				end
			end

			Result := flag

		end

feature{NONE} -- Queries
	int_to_board_coordinates(v: INTEGER): TUPLE[i: INTEGER; j: INTEGER]
		require
			v >= 1 and v <= board_height*board_height
		local
			rem: INTEGER
			div: INTEGER
			i: INTEGER -- row
			j: INTEGER -- col
		do
			rem := v \\ board.board_width
			div := v // board.board_width


			j := rem
			if j = 0 then
				j := board.board_width
			end

			i := div
			if rem /= 0 then
				i := i + 1
			end

			Result := [i, j]

		end

end




