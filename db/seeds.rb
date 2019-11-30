if User.find_by_username('dev').blank?
  User.create! \
    username: 'dev',
    password: 'password',
    password_confirmation: 'password'
end

if User.find_by_username('user1').blank?
  User.create! \
    username: 'user1',
    password: 'password',
    password_confirmation: 'password'
end

if User.find_by_username('user2').blank?
  User.create! \
    username: 'user2',
    password: 'password',
    password_confirmation: 'password'
end
