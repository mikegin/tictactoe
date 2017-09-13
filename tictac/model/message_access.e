note
	description: "Singleton accessor for {MESSAGE}."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MESSAGE_ACCESS

feature
	m: MESSAGE
		once
			create Result.make
		end

invariant
	m = m
end
