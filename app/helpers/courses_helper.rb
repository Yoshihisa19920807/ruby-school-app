module CoursesHelper
  def enrollment_button(course)
    if current_user
      # p "courseid"
      # p course.title
      # p "course.enrollments.where(user: current_user)"
      # p course.enrollments.where(user: current_user)
      # p "course.enrollments.where(user: current_user).any?"
      # p course.enrollments.where(user: current_user).any?
      if course.user == current_user
        link_to "You created this course. View analytics", course_path(course)
        p "created"
        p course.title
      elsif course.enrollments.where(user: current_user).any?
        p "in_course.enrollments.where(user: current_user).any?"
        p course.title
        link_to "You bought this course. Keep learning", course_path(course)
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: 'btn btn-success text-light'
      else
        p "else"
        p course.title
        link_to "$Free", new_course_enrollment_path(course), class: 'btn btn-success text-light'
      end
    else
      unless current_page?(course_path(course))
        link_to "Check the price", course_path(course), class: "btn btn-md btn-success text-light"
      else 
        number_to_currency(course.price)
      end
    end
  end
end
