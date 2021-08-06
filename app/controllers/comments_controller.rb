class CommentsController < ApplicationController

  def create
    p "create\\params"
    p params
    @comment = Comment.new(comment_params)
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    @comment.lesson_id = @lesson.id
    @comment.user = current_user
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@course, @lesson], notice: "Comment was successfully submitted." }
        format.json { render :show, status: :created, location: @lesson }
      else
        flash.now[:alert] = "The process wasn't done properly."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    p "new_comment!!"
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
