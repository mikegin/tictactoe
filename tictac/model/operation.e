note
	description: "Deferred class representing user operations."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION
feature -- Commands

	--Executes the operation
	execute
		deferred
		end

	--Undoes the operation
	undo
		deferred
		end

	--Redoes the operation
	redo
		deferred
		end

end
