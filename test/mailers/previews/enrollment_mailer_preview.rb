# Preview all emails at http://localhost:3000/rails/mailers/enrollment_mailer
class EnrollmentMailerPreview < ActionMailer::Preview
  def student_enrollment
    EnrollmentMailer.with(enrollment: Enrollment.last).student_enrollment(Enrollment.last)
  end

  def teacher_enrollment
    # .teacher_enrollment(Enrollment.last)ここの部分で参照するenrollmentを指定している
    EnrollmentMailer.with(enrollment: Enrollment.last).teacher_enrollment(Enrollment.last)
  end
end
