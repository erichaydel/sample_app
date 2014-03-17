class UsersController < ApplicationController
	before_action :signed_in_user, 	only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   	only: [:edit, :update]
	before_action :admin_user, 			only: :destroy
	before_action :hide_new_user,		only: [:new, :create]
	
	def index
		@users = User.paginate(page: params[:page])
	end
	
	def show
		@user = User.find(params[:id])
	end
	
	def new
		@user = User.new
  end
	
	def create
		@user = User.new(user_params)
		
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			flash[:error] = "You fucked up"
			render 'new'
		end
	end
	
	def edit
	end
	
	def update
		@user = User.find(params[:id])
		
		if @user.update_attributes(user_params)
			sign_in @user
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end
	
	def destroy
		user = User.find(params[:id])
		if !current_user?(user)				# If current user is not user to delete
			user.destroy
			flash[:success] = "User destroyed"
			redirect_to users_path
		else
			redirect_to root_path
		end
	end
	
	private
	
		def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
		
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_url, notice: "Please sign in." 
			end
		end
		
		def correct_user
			@user = User.find(params[:id])
			redirect_to root_path unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
		
		def hide_new_user
			if signed_in?
				redirect_to current_user
			end
		end
	
end
