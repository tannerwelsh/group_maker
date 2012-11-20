class UsersController < ApplicationController
  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user || User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_path, notice: 'Update successful.' }
        format.json { head :no_content }
      else
        format.html { render template: 'projects/index' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
