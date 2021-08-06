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

  def edit
    p "edit_comment!!!!"
    p params
    @comment = Comment.find(params[:id])
    authorize @comment
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    # render file: "#{Rails.root}/app/views/lessons/comments/edit.html.haml", comment: @comment
    # app/views/lessons/comments/_comment.html.haml
    # /mnt/c/Users/USER/Projects/ruby-gems-bootcamp/app/views/lessons/comments/_comment.html.haml
  end

  def update
    p "update\\params"
    p params
    @comment = Comment.find(params[:id])
    authorize @comment
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])    
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to [@course, @lesson], notice: "Comment was successfully submitted." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        flash.now[:alert] = "The process wasn't done properly."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
