note
	description: "Singleton accessor for {STATUS}."
	author: "Mikhail Gindin"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	STATUS_ACCESS

feature
	m: STATUS
		once
			create Result.make
		end

invariant
	m = m
end
