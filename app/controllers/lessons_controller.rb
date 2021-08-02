class LessonsController < ApplicationController
  before_action :set_lesson, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, :only => [:show]

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    authorize @lesson
    @lesson.view_lesson
    @lessons = @lesson.course.lessons
    # raise "This is an exception"
  end

  # GET /lessons/new
  def new
    # p "_____params"
    # p params
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
        format.html { redirect_to [@course, @lesson], notice: "Lesson was successfully created." }
        format.json { render :show, status: :created, location: @lesson }
      else
        flash.now[:alert] = "The process wasn't done properly."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    authorize @lesson
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to [@course, @lesson], notice: "Lesson was successfully updated." }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    authorize @lesson
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: "Lesson was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      @lesson = Lesson.friendly.find(params[:id])
      @course = @lesson.course
    end

    # Only allow a list of trusted parameters through.
    def lesson_params
      params.require(:lesson).permit(:title, :content, :course_id)
    end
end
