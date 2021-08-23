class EnrollmentMailer < ApplicationMailer
  # default from: "from@example.com"
  # layout 'mailer'

  # same name with the view file
  def student_enrollment(enrollment)
    p "enroll mailer was called"
    @enrollment = enrollment
    @course = enrollment.course
    mail(to: @enrollment.user.email, subject: "You have enrolled to: #{@course}")
    #mail(to: @enrollment.course.user.email, subject: "You have a new student in: #{@course}")
  end

  def teacher_enrollment(enrollment)
    @enrollment = enrollment
    @course = enrollment.course
    mail(to: @enrollment.course.user.email, subject: "New student #{@enrollment.user.email} enrolled to: #{@course}")
  end
end
