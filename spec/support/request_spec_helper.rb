module RequestSpecHelper
  def login_as(user)
    post "/login", params: { email: user.email, password: "password123" }
  end

  def logout
    delete "/logout"
  end

  def json_response
    JSON.parse(response.body)
  end
end