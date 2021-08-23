class Courses::CourseWizardsController < ApplicationController
  include Wicked::Wizard

  steps :first, :second, :third

  before_action :set_course, only: %i[ show update finish_wizard_path]
  # skip_before_action :authenticate_user!, :only => [:index, :show]
  before_action :set_progress, only: %i[ show update ]

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
    p "____@progress"
    p @progress
    # @course = Course.friendly.find params[:course_id]
    # case step
    # when
    # end
    case step
    when :first
    when :second
      @tags = Tag.all
    when :third
    end
    render_wizard
    # p "_____wizard_steps"
    # p wizard_steps.index(step)
    # p "_____step"
    # p wizard_steps.count
  end

  def update
    case step
    when :first
      @course.update_attributes(course_params)
    when :second
      @tags = Tag.all
      @course.update_attributes(course_params)
    when :third
      @course.update_attributes(course_params)
    end
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
      :title, :description, :short_description, :language, :level, :price, :published, :avatar,
      course_tags_attributes: [:id, :tag_id, :_destroy,
        tag_attributes: [:id, :name, :_destroy]
      ],
      tag_ids: []
    )
  end

  def set_progress
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress = (wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d * 100
    else
      @progress = 0
    end
  end
end
