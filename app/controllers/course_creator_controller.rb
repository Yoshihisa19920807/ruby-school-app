class CourseCreatorController < ApplicationController
  include Wicked::Wizard

  steps :first, :second, :third

  before_action :set_course, only: %i[ show edit update destroy]
  skip_before_action :authenticate_user!, :only => [:index, :show]
  before_action :set_progress, only: %i[ show edit update destroy]

  def new
    @course = Course.new
    @course.course_tags.build
    case step
    when :first
    end
    # authorize @course
    render_wizard @course
  end

  def show
    p "____@progress"
    p @progress
    # case step
    # when
    # end
    render_wizard @course
    p "_____wizard_steps"
    p wizard_steps.index(step)
    p "_____step"
    p wizard_steps.count
  end

  def finish_wizard_path
    user_path(current_user)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    # @course = Course.friendly.find(params[:id])
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
    p "hoge_"
    p wizard_steps.index(step) + 1
    p "fuga_"
    p wizard_steps.count
    p 1.to_d / 3.to_d
    if wizard_steps.any? && wizard_steps.index(step).present?
      @progress = (wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d * 100
    else
      @progress = 0
    end
  end
end
