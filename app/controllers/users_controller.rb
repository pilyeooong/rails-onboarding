class UsersController < ApplicationController
  before_action :authorized, only: [:index, :destroy]

  def index
    render json: @user, status: :ok
  end

  def create
    @user = User.new(create_params)
    if @user.save
      render json: { message: 'User created Successfully' }, status: :created
    else
      # puts @user.errors.inspect
      render json: { message: 'Failed to create User', errors: @user.errors }, status: :conflict
    end
  end

  def login
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token(@user.id)
      render json: { user: @user, token: token }
    else
      render json: { message: 'Invalid Email or Password' }
    end
  end

  def destroy
    User.destroy(@user.id)
    render json: { message: 'User successfully deleted' }
  end

  private
    def create_params
      params.permit(:email, :password)
    end

end