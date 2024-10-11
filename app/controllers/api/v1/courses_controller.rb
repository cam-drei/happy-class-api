class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_course, except: [:index]

  def index
    courses = Course.all
    render json: { courses: courses }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def lessons_for_course
    course_id = params[:course_id]
  
    selected_user_subjects = current_user.selected_user_subjects_for_course(course_id)
    selected_subject_ids = selected_user_subjects.pluck(:subject_id)
  
    lessons = @course.lessons.includes(:contents, subject_lessons: [:subject, :user_subject_lessons])
    
    lessons = lessons.select do |lesson|
      lesson.subject_lessons.any? { |subject_lesson| selected_subject_ids.include?(subject_lesson.subject_id) }
    end
    
    lessons_details = lessons.map do |lesson|
      {
        id: lesson.id,
        name: lesson.name,
        done: lesson.subject_lessons.all? { |sl| current_user.user_subject_lessons.exists?(subject_lesson: sl, done: true) },
        contents: lesson.contents.as_json(only: [:id, :video_link, :document_link]),
        subject_lessons: lesson.subject_lessons.select do |subject_lesson|
          selected_subject_ids.include?(subject_lesson.subject_id)
        end.map do |subject_lesson|
          user_subject_lesson = current_user.user_subject_lessons.find_by(subject_lesson: subject_lesson)
      
          {
            id: subject_lesson.id,
            done: user_subject_lesson&.done || false,
            subject_name: subject_lesson.subject.name,
            contents: subject_lesson.contents.as_json(only: [:id, :video_link, :document_link])
          }
        end
      }
    end
  
    render json: lessons_details, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def contents_for_course
    contents = @course.contents
    render json: { contents: contents }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def subjects_for_course
    subjects = @course.subjects
    render json: { subjects: subjects }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end

  def course_status
    course = Course.find_by(id: params[:course_id])
    if course
      lesson_ids = course.lessons.pluck(:id)
      done_lessons_count = 0
  
      lesson_statuses = course.lessons.includes(:subject_lessons).each do |lesson|
        selected_user_subjects = current_user.user_subjects.where(subject_id: lesson.subject_lessons.pluck(:subject_id))
  
        if selected_user_subjects.exists?
          lesson_done = lesson.subject_lessons.all? do |sl|
            current_user.user_subject_lessons.exists?(subject_lesson: sl, done: true)
          end
  
          if lesson_done
            done_lessons_count += 1
          end
  
          UserLesson.find_or_initialize_by(lesson_id: lesson.id, user_id: current_user.id).update(done: lesson_done)
        end
      end
  
      total_lessons_count = course.lessons.joins(:subject_lessons)
                                .where(subject_lessons: { subject_id: current_user.user_subjects.pluck(:subject_id) })
                                .distinct.count

      status = if total_lessons_count == 0
        'No Lesson'
      elsif done_lessons_count == total_lessons_count
        'Done'
      elsif done_lessons_count > 0
        'In Progress'
      else
        'Todo'
      end
  
      render json: { status: status }, status: :ok
    else
      render json: { error: 'Course not found' }, status: :not_found
    end
  rescue StandardError => e
    Rails.logger.error "Error: #{e.message}"
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end

  private

  def done_lessons_count(lessons)
    lesson_ids = lessons.pluck(:id)
    UserLesson.where(lesson_id: lesson_ids, user_id: current_user.id, done: true).count
  end

  def find_course
    @course = current_user.courses.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Course not found' }, status: :not_found
  end
end
