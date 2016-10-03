
locations = { countries:
	[
		{ name: "Украина", states: 
			[
				{ name: "Киевская", cities: ["Белая Церковь",
					"Березань","Богуслав","Борисполь","Боярка", "Бровары",
					"Буча", "Васильков", "Вишневое", "Вышгород","Ирпень",
					"Кагарлык", "Киев", "Мироновка", "Обухов",
					"Переяслав-Хмельницкий", "Припять", "Ржищев","Сквира",
					"Славутич", "Тараща", "Тетиев", "Узин", "Украинка",
					"Фастов", "Чернобыль", "Яготин"]},
				{ name: "Черниговская", cities: ["Батурин", "Бахмач",
					"Бобровица", "Борзна", "Городня", "Ичня", "Корюковка",
					"Мена", "Нежин", "Новгород-Северский", "Носовка",
					"Остёр","Прилуки", "Семёновка", "Сновск", "Чернигов"]},
				{ name: "Сумская", cities: [] }
			] 
		},
		{ name: "Россия", states: 
			[
				{ name: "Новгородская", cities: ["Боровичи", "Валдай",
					"Великий Новгород", "Малая Вишера", "Окуловка",
					"Пестово", "Сольцы", "Старая Русса", "Холм","Чудово"]}
			] 
		},
		{ name: "Белоруссия", states: []}
	]
}
unless City.find_by(name: "Киев")
	ActiveRecord::Base.transaction do
		locations[:countries].each do |country|
			Country.create(name: country[:name])
			country[:states].each do |state|
				if state[:name]
					State.create(name: state[:name], 
						country_id: Country.find_by(name: country[:name]).id)
					if state[:cities]
						state[:cities].each do |city|
							City.create(name: city, 
								state_id: State.find_by(name: state[:name]).id)
						end
					end
				end
			end
		end
	end
end