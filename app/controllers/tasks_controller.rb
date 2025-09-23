class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]
  include QuotesHelper  # ✅ allow access to random_quote method

  # GET /tasks
  def index
    @tasks = current_user.tasks
    @tasks = @tasks.where(category: params[:category]) if params[:category].present?
    # Optional: sort so tasks with no due_date appear last
    @tasks = @tasks.order(Arel.sql("due_date IS NULL, due_date ASC"))
    # ✅ Pagination: show 6 tasks per page
    @tasks = @tasks.page(params[:page]).per(6)
  end

  # GET /tasks/:id
  def show
    # show page is also used for editing
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build(title: params[:title]) # Prefill title if passed
    render :show
  end

  # POST /tasks
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      if @task.completed? # ✅ check if the task is marked completed
        redirect_to @task, notice: random_quote, status: :see_other
      else
        redirect_to @task, notice: "Task was successfully updated.", status: :see_other
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy!
    redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other
  end

  # GET /tasks/calendar
  def calendar
    # Include all tasks, even without due_date
    @tasks = current_user.tasks.order(Arel.sql("due_date IS NULL, due_date ASC"))
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :details, :completed, :due_date, :category)
  end
end
