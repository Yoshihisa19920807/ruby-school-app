class TagsController < ApplicationController
  def index
    if current_user.has_role?(:admin)
      @tags = Tag.all
    else
      redirect_to root_path, alert: 'You do not have the right to access'
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render json: @tag
    else
      render json: { errors: @tag.errors.full_messages }
    end
  end

  def destroy
    @tag = Tag.find(params[:id])

    authorize @tag
    if @tag.destroy
      respond_to do |format|
        format.html do
          redirect_to tags_path, notice: 'Tag was successfully destroyed.'
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to tags_path, alert: "Tag wasn't destroyed" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
