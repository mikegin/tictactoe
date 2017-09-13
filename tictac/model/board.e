note
	description: "Game board representing a TicTacToe board"
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD

inherit
	ANY
		redefine
			out
		end
create
	make

feature -- Initialization
	make(i: INTEGER; j: INTEGER)
		require
			i > 0 and j > 0
		do
			create board.make (i, j)
			board.fill_with ('_')
		end

feature{NONE} -- Attributes
	board: ARRAY2[CHARACTER] -- Game board

feature -- Commands
	set(c: CHARACTER; i: INTEGER; j: INTEGER)
			-- Set the board character at position (i, j)
		require
			is_valid_row_pos(i) and is_valid_col_pos(j)
		do
			board.put (c, i, j)
		ensure
			is_valid_row_pos(i) and is_valid_col_pos(j) implies board.item (i, j) ~ c
		end

	get(i: INTEGER; j: INTEGER): CHARACTER
			-- Get the board character at position (i, j)
		require
			is_valid_row_pos(i) and is_valid_col_pos(j)
		do
			Result := board.item (i, j)
		end

	clear
		do
			board.fill_with (default_char)
		end

feature -- Queries
	is_valid_row_pos(i: INTEGER): BOOLEAN
			-- Valid row?
		do
			Result := i <= board.height and i >= 1
		end

	is_valid_col_pos(j: INTEGER): BOOLEAN
			--Valid column
		do
			Result := j <= board.width and j >= 1
		end

	board_height: INTEGER
		do
			Result := board.height
		end

	board_width: INTEGER
		do
			Result := board.width
		end

	default_char: CHARACTER = '_'

	board_is_full: BOOLEAN
			-- checks if the board is full of non default characters
		local
			i: INTEGER
			j: INTEGER
		do
			from
				Result := true
				i := 1
			until
				not Result or else i > board_height
			loop
				from
					j := 1
				until
					not Result or else j > board_width
				loop
					if board.item (i, j) ~ default_char then
						Result := false
					end

					j := j + 1
				end

				i := i + 1
			end
		end

	out: STRING
		local
			i: INTEGER
			j: INTEGER
		do
			create Result.make_empty
			from
				i := 1
			until
				i > board.height
			loop
				Result := Result +  "  "
				from
					j := 1
				until
					j > board.width
				loop
					Result := Result + board.item (i, j).out
					j := j + 1
				end
				if i /= board.height then
					Result := Result + "%N"
				end
				i := i + 1
			end
		end
end
