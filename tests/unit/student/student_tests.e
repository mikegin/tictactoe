note
	description: "My unit tests"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature{NONE} -- Initialization
	make
		do
			add_boolean_case (agent t_board_create)
			add_boolean_case (agent t_new_game_execute)
			add_boolean_case (agent t_play_execute)
			add_boolean_case (agent t_winner_check)
			add_boolean_case (agent t_board_full)
		end

feature -- Tests
	board_string: STRING = "  X_%N  __"

	t_board_create: BOOLEAN
			-- Test board creation
		local
			b: BOARD
			default_char: CHARACTER
		do
			comment("t_board_create: test board creation")
			create b.make(2, 2)
			default_char := b.default_char
			b.set ('X', 1, 1)
			sub_comment(board_string)
			sub_comment(b.out)
			Result := b.get (1, 1) ~ 'X' and b.get (1, 2) ~ default_char and b.get (2, 1) ~ default_char and b.get (2, 2) ~ default_char and board_string ~ b.out
		end

	t_new_game_execute: BOOLEAN
		local
			g: GAME_ACCESS
		do
			comment("t_new_game: test new game command")
			g.m.new_game ("Bob", "Sam")
			Result := g.m.player1.name ~ "Bob" and g.m.player2.name ~ "Sam" and g.m.player1.char ~ 'X' and g.m.player2.char ~ 'O'
			g.m.reset
		end

	t_play_execute: BOOLEAN
		local
			g: GAME_ACCESS
		do
			comment("t_play_execute: test play execute")
			g.m.new_game ("Bob", "Sam")
			g.m.play ("Sam", 5)
			Result := g.m.board.get (2, 2) ~ g.m.board.default_char
			check Result end
			g.m.play ("Bob", 5)
			sub_comment(g.m.board.out)
			Result := g.m.board.get (2, 2) ~ g.m.player1.char
			g.m.reset
		end

	t_winner_check: BOOLEAN
		local
			g: GAME_ACCESS
			i: INTEGER
			j: INTEGER
		do
			comment("t_winner_check: test winner check function")

			-- Check winners by row
			from
				i := 1
			until
				i > g.m.board.board_height
			loop
				from
					j := 1
				until
					j > g.m.board.board_width
				loop
					g.m.board.set ('X', i, j)
					j := j + 1
				end
				Result := g.m.check_for_winner
				check Result end
				g.m.board.clear
				i := i + 1
			end

			-- Check winners by coloumn
			from
				i := 1
			until
				i > g.m.board.board_width
			loop
				from
					j := 1
				until
					j > g.m.board.board_height
				loop
					g.m.board.set ('X', j, i)
					j := j + 1
				end
				Result := g.m.check_for_winner
				check Result end
				g.m.board.clear
				i := i + 1
			end

			-- Check winners by \ diagonal
			from
				i := 1
				j := 1
			until
				i > g.m.board.board_height
			loop
				g.m.board.set ('X', i, j)
				i := i + 1
				j := j + 1
			end
			Result := g.m.check_for_winner
			check Result end
			g.m.board.clear

			-- Check winners by / diagonal
			from
				i := 1
				j := g.m.board.board_width
			until
				i > g.m.board.board_height
			loop
				g.m.board.set ('X', i, j)
				i := i + 1
				j := j - 1
			end
			Result := g.m.check_for_winner
			check Result end
			g.m.reset


		end

	t_board_full: BOOLEAN
		local
			b: BOARD
		do
			comment("t_board_full: test board is full query in BOARD class")
			create b.make (2, 2)

			Result := b.board_is_full
			check not Result end

			b.set ('X', 2, 1)
			Result := b.board_is_full
			check not Result end

			b.set ('O', 1, 1)
			b.set ('X', 1, 2)
			b.set ('O', 2, 2)
			Result := b.board_is_full
		end

end
