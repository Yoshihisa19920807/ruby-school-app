class EnrollmentsController < ApplicationController
  # ↓ before_action :set_enrollment, only: [:show, :edit, :update, :destroy, :certificate]
  before_action :set_enrollment, only: %i[ show edit update destroy certificate]
  skip_before_action :authenticate_user!, only: %i[ certificate ]
  before_action :set_course, only: %i[ new create ]

  # GET /enrollments or /enrollments.json
  def index
    @q = Enrollment.ransack(params[:q])
    # p "_____@q"
    # p @q.result.includes(:course, :user)
    # @q.result.includes(:course, :user).each do |result|
    #   p "___result"
    #   p result
    # end
    @pagy, @enrollments =  pagy(@q.result.includes(:course, :user))
    authorize @enrollments
    # @pagy, @courses = pagy(@courses_ransack.result.includes(:user))
    # authorizeするオブジェクトのクラスモデルのポリシー（※コントローラ名と一致する必要あり。一致しない場合はapplication__olicyに飛ばされる）を参照する。この場合はenrollment_policy。
    @ransack_path = enrollments_path
  end

  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: {user: current_user}).ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    authorize @enrollments
    render 'index'
  end

  def certificate
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
        page_size: 'A4',
        template: "enrollments/certificate.pdf.haml",
        layout: "pdf.html.haml",
        orientation: "Landscape",
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
    authorize @enrollment
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
    @enrollment.course = @course
    # authorize @enrollment
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create

    # if @course.price > 0
    #   flash.now[:alert] = "This course is currently unavailable."
    #   render :new

    #   # flash[:alert] = "You can not access paid courses yet."
    #   # redirect_to new_course_enrollment_path(@course)
    # else
      @enrollment = Enrollment.new(course: @course, user: current_user, price: @course.price)
      respond_to do |format|
        if @enrollment.save
          p "save_enrollment_succeeded___"
          format.html { redirect_to @course, notice: "Enrollment was successfully created." }
          format.json { render :show, status: :created, location: @enrollment }
          EnrollmentMailer.student_enrollment(@enrollment).deliver_later
          EnrollmentMailer.teacher_enrollment(@enrollment).deliver_later
        else
          p "save_enrollment_failed___"
          p @enrollment.errors
          flash.now[:alert] = "The process wasn't done properly."
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        end
      # end
      # # @course = Course.friendly.find(params[:course_id])
      # @enrollment = Enrollment.create(course: @course, user: current_user, price: @course.price)
      # redirect_to course_path(@course)
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        # Course.friendly.find(@enrollment.course_id).update(average_rating: Enrollment.friendly.where(course: @enrollment.course).average(:rating))
        format.html { redirect_to @enrollment, notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.friendly.find(params[:id])
    end

    def set_course
      @course = Course.friendly.find(params[:course_id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:user_id, :course_id, :rating, :price, :review)
    end
end
