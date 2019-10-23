# Generate sample users
SAMPLE_USERS = 5
(1..SAMPLE_USERS).each do |idx|
  User.create do |user|
    user.email = "user_#{idx}@ucsd.edu"
    user.uid = "user_#{idx}"
    user.full_name = "Employee, User #{idx}"
    user.provider = "developer"
  end
end

# Support Mac OS and Linux for using shuffle
shuffle_bin =
  case Gem::Platform.local.os
  when 'linux' then 'shuf'
  when 'darwin' then 'gshuf'
  end

# extract dictionary if doesn't exist
unless File.exist?("./vendor/dictionary")
  `tar -zxvf ./vendor/dictionary.tar.gz -C ./vendor`
end

# Generate sample recognitions
SAMPLE_RECOGNITIONS = 20
(1..SAMPLE_RECOGNITIONS).each do
  Recognition.create do |recognition|
    random_description = `#{shuffle_bin} -n 100 vendor/dictionary | awk '{print}' ORS=' '`.chomp
    recognition.description = random_description
    recognition.library_value = LIBRARY_VALUES.values.sample
    recognition.user = User.order('RANDOM()').first
    recognition.employee = Employee.order('RANDOM()').first
  end
end
