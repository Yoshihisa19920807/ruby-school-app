class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy approve unapprove analytics]
  skip_before_action :authenticate_user!, :only => [:index, :show]

  # GET /courses or /courses.json
  def index
    # if params[:title]
    #   @courses = Course.where('title ILIKE ?', "%#{params[:title]}%") #case-insensitive
    # else
    #   # @courses = Course.all
    #   @q = Course.ransack(params[:q])
    #   @courses = @q.result.includes(:user)
    # end

    @ransack_path = courses_path
    @pagy, @courses = pagy(@courses_ransack.result.includes(:user, :tags))
    @tags = Tag.all
    # @activities = PublicActivity::Activity.all
    # p "@courses"
    # p @courses
  end

  def teaching
    @ransack_path = teaching_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :tags))
    @tags = Tag.all
    render 'index'
  end

  def purchased
    @ransack_path = purchased_courses_path
    @q = Course.includes(:enrollments).where(enrollments: {user: current_user}).ransack(params[:search_courses], search_key: :search_courses)
    @pagy, @courses = pagy(@q.result.includes(:enrollments, :tags))
    @tags = Tag.all
    render "index"
  end

  def review_pending
    @ransack_path = purchased_courses_path
    @q = Course.includes(:enrollments).where(enrollments: {user: current_user, rating: nil}).ransack(params[:search_courses], search_key: :search_courses)
    @pagy, @courses = pagy(@q.result.includes(:enrollments, :tags))
    @tags = Tag.all
    render "index"
  end

  def created
    p "created"
    @ransack_path = created_courses_path
    @q = Course.includes(:user).where(user: current_user).ransack(params[:search_courses], search_key: :search_courses)
    @pagy, @courses = pagy(@q.result.includes(:user, :tags))
    @tags = Tag.all
    render "index"
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user, :tags))
    @tags = Tag.all
    render 'index'
  end

  def approve
    # :approve? -> methodを設定
    authorize @course, :approve?
    @course.update_attribute(:approved, true)
    redirect_to @course, notice: "Course approved and visible!"
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attribute(:approved, false)
    redirect_to @course, notice: "Course upapproved and hidden!"
  end

  def analytics
    # :でメソッドを指名出来る
    authorize @course, :edit?
  end

  # GET /courses/1 or /courses/1.json
  def show
    p "course_show_"
    authorize @course
    # @pagy, @lessons = pagy(@course.lessons.rank(:row_order), items: 5)
    @lessons = @course.lessons.rank(:row_order)
    # @enrollment = Enrollment.find_by(user_id: current_user.id, course_id: @course.id) if current_user.present?
    @enrollments_with_review = @course.enrollments.reviewed
    respond_to do |format|
      p "espond_to do |format|"
      format.html
      format.pdf do
        # expects there is a file named show.pdf.haml
        render pdf: "#{@course.title}, #{current_user.email}",   # Excluding ".pdf" extension.
               low_quality: true
      end
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    @course.course_tags.build
    authorize @course
  end

  # GET /courses/1/edit
  def edit
    # authorize by pundit
    # p "courses_controller_def_edit"

    # refers to edit method in course_policy
    authorize @course
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user

    authorize @course

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        # flash.now[:alert] = "The process wasn't done properly."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    authorize @course
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to teaching_courses_path, notice: "Course was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @course, alert: "Course wasn't destroyed" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(
        :title, :description, :short_description, :language, :level, :price, :published, :avatar,
        course_tags_attributes: [:id, :tag_id, :_destroy,
          tag_attributes: [:id, :name, :_destroy]
        ],
        tag_ids: []
      )
    end
end
