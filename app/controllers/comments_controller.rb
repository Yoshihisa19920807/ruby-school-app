class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    @comment.lesson_id = @lesson.id
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html do
          redirect_to [@course, @lesson],
                      notice: 'Comment was successfully submitted.'
        end
        format.json { render :show, status: :created, location: @lesson }
      else
        # flash.now[:alert] = "The process wasn't done properly."
        # format.html { redirect_to [@course, @lesson], notice: "Comment was successfully submitted." }
        # format.html { redirect_back(fallback_location: [@course, @lesson]) }
        format.html do
          redirect_to request.referrer,
                      alert: "The process wasn't done properly."
        end
        # format.html { render 'lessons/comments/new' }
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def show
  end

  def new
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize @comment
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    # View下のPathを書けばOK
    render 'lessons/comments/edit'
  end

  def update
    @comment = Comment.find(params[:id])
    authorize @comment
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html do
          redirect_to [@course, @lesson],
                      notice: 'Comment was successfully submitted.'
        end
        format.json { render :show, status: :ok, location: @lesson }
      else
        # flash.now[:alert] = "The process wasn't done properly."
        format.html do
          render 'lessons/comments/edit', status: :unprocessable_entity
        end
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @lesson = Lesson.friendly.find(params[:lesson_id])
    @course = Course.friendly.find(params[:course_id])
    respond_to do |format|
      if @comment.destroy!
        format.html do
          redirect_to [@course, @lesson],
                      notice: 'Comment was successfully deleted.'
        end
        format.json { render :show, status: :ok, location: @lesson }
      else
        # flash.now[:alert] = "The process wasn't done properly."
        format.html do
          redirect_to [@course, @lesson],
                      alert: "The process wasn't done properly."
        end
        format.json do
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
