class Courses::CourseWizardsController < ApplicationController
  include Wicked::Wizard

  steps :first, :second, :lesson, :third

  before_action :set_course, only: %i[show update finish_wizard_path]
  # skip_before_action :authenticate_user!, :only => [:index, :show]
  before_action :set_progress, only: %i[show update]

  def new
    @course = Course.new
    @course.course_tags.build
    case step
    when :first
    when :second
      @tags = Tag.all
    when :third
    end
    # authorize @course
    render_wizard @course
  end

  def show
    case step
    when :first
    when :second
      @tags = Tag.all
    when :lesson
      # deal with the case when there's no lesson
      @course.lessons.build unless @course.lessons.any?
    when :third
    end
    render_wizard
  end

  def update
    case step
    when :first
    when :second
      @tags = Tag.all
    when :lesson
    when :third
      flash[:notice] = 'Course was successfully updated.'
    end
    @course.update(course_params)
    render_wizard @course
  end

  def finish_wizard_path
    # @course = Course.friendly.find(params[:course_id])
    course_path(@course)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.friendly.find(params[:course_id])
    # @enrollment = @course.enrollments.where(user: current_user).first
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(
      :title,
      :description,
      :short_description,
      :language,
      :level,
      :price,
      :published,
      :avatar,
      course_tags_attributes: [
        :id,
        :tag_id,
        :_destroy,
        tag_attributes: %i[id name _destroy],
      ],
      tag_ids: [],
      lessons_attributes: %i[
        title
        content
        course_id
        row_order_position
        video
        video_thumbnail
        _destroy
      ],
    )
  end

  def set_progress
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress =
        (wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d * 100
    else
      @progress = 0
    end
  end
end
