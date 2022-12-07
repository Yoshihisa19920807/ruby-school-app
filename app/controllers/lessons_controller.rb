class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[show edit update destroy delete_video]
  skip_before_action :authenticate_user!, only: [:show]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    authorize @lesson
    @lesson.view_lesson
    @lessons = @lesson.course.lessons.rank(:row_order)
    # raise "This is an exception"
    @comment = Comment.new
    @comments = @lesson.comments
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
    @course = Course.friendly.find(params[:course_id])
    @lesson.course_id = @course.id
    authorize @lesson
  end

  # GET /lessons/1/edit
  def edit
    authorize @lesson
  end

  # POST /lessons or /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    @course = Course.friendly.find(params[:course_id])
    @lesson.course_id = @course.id
    authorize @lesson
    respond_to do |format|
      if @lesson.save
        format.html do
          redirect_to [@course, @lesson],
                      notice: 'Lesson was successfully created.'
        end
        format.json { render :show, status: :created, location: @lesson }
      else
        flash.now[:alert] = "The process wasn't done properly."
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @lesson.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    authorize @lesson
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html do
          redirect_to [@course, @lesson],
                      notice: 'Lesson was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @lesson.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    authorize @lesson
    if @lesson.destroy!
      respond_to do |format|
        format.html do
          redirect_to course_path(@course),
                      notice: 'Lesson was successfully destroyed.'
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :show, status: :unprocessable_entity }
        format.json do
          render json: @lesson.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def delete_video
    authorize @lesson, :edit?
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course, @lesson),
                notice: 'Video successfully deleted!'
  end

  def sort
    @course = Course.friendly.find(params[:course_id])
    lesson = Lesson.friendly.find(params[:lesson_id])
    authorize lesson, :edit?
    lesson.update(lesson_params)
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.friendly.find(params[:id])
    @course = @lesson.course
  end

  # Only allow a list of trusted parameters through.
  def lesson_params
    params.require(:lesson).permit(
      :title,
      :content,
      :course_id,
      :row_order_position,
      :video,
      :video_thumbnail,
    )
  end
end
