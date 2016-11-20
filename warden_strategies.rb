# coding: UTF-8

Warden::Strategies.add :custom_login_strategy do

	def valid?
		params['user_name'] || params['user_pass']
	end

	def authenticate!
		p "3"
		user = get_user(params['user_name'].strip)
		if user.nil? || user.user_pass != params['user_pass'].strip
			fail!('cannot login')
		else
			success!(user)
		end
	end

end

Warden::Manager.serialize_into_session do |user|
	user
end

Warden::Manager.serialize_from_session do |user_name|
	user = get_user(user_name)
	user.delete(:user_pass)
	return user
end
