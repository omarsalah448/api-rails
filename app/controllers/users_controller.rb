class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  skip_before_action :authorized, only: [ :create ]
  def index
    render json: User.all
  end
  def show
    render json: @user
  end
  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token(user_id: @user.id)
      render json: {
        user: UserSerializer.new(@user),
        token: token
        }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end
  def update
    if @user.update(user_params)
      render json: @user
    else
      render @user.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @user.destroy
    head :no_content
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    def set_user
      @user = User.find_by(id: params[:id])
    end
end
