class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to request.referer || root_path, notice: "You have followed this user."
  end

  def destroy
    relationship = current_user.active_relationships.find(params[:id])
    relationship.destroy
    redirect_to request.referer || root_path, notice: "You have unfollowed this user."
  end
end
