
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
					"Остёр","Прилуки", "Семёновка", "Сновск", "Чернигов"]}#,
				#{ name: "Сумская", cities: [] }
			] 
		}#,
		#{ name: "Россия", states: 
			#[
				#{ name: "Новгородская", cities: ["Боровичи", "Валдай",
				#	"Великий Новгород", "Малая Вишера", "Окуловка",
				#	"Пестово", "Сольцы", "Старая Русса", "Холм","Чудово"]}
			#] 
		#},
		#{ name: "Белоруссия", states: []}
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

if User.count < 0 
	ActiveRecord::Base.transaction do
		100.times do |i|
			firstName = Faker::Name.first_name
			User.create!(
				first_name: firstName,
				last_name: Faker::Name.last_name,
				email: firstName + i.to_s + "@#{Faker::Internet.domain_name}",
				password: "testpass",
				password_confirmation: "testpass",
				confirmed_at: Time.now
			)
		end
	end
end