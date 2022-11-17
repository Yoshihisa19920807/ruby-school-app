module CoursesHelper
  def enrollment_button(course)
    if current_user
      if course.user == current_user
        link_to "You created this course. View analytics", course_path(course)
      # elsif course.enrollments.where(user: current_user).any?
      elsif course.bought?(current_user)
        # link_to "You bought this course. Keep learning", course_path(course)
        link_to "Progress: #{number_to_percentage(course.progress(current_user), precision: 1 )}", course_path(course)
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success text-light'
      else
        link_to "$Free", new_course_enrollment_path(course), class: 'btn btn-success text-light'
      end
    else
      unless current_page?(course_path(course))
        # link_to "Check the price", course_path(course), class: "btn btn-md btn-success text-light"
        link_to "Check price", new_course_enrollment_path(course), class: "btn btn-md btn-success"
      else
        number_to_currency(course.price)
      end
    end
  end

  def review_button(course)
    if current_user
      enrollment = course.enrollments.where(user: current_user).first
      if enrollment.present?
        if enrollment.rating == nil
          link_to edit_enrollment_path(enrollment) do
            "<i class='text-warning fa fa-star'></i>".html_safe + " " +
            'Add a review'
          end
        else
          link_to enrollment_path(enrollment) do
            "<i class='text-warning fa fa-star'></i>".html_safe + " " +
            "<i class='text-success fa fa-check'></i>".html_safe + " " +
            'Thanks for reviewing!'
          end
        end
      end
    end
  end

  def certificate_button course
    if current_user
      enrollment = course.enrollments.where(user: current_user).first
      if enrollment
        if course.progress(current_user) == 100
          link_to certificate_enrollment_path(enrollment, format: :pdf) do
            "<i class='text-success fas fa-stamp'></i>".html_safe + " " +
            "Issue the Certificate"
          end
        else
          "Certificate available after completion"
        end
      end
    end
  end
end
