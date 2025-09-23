class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: [ :show, :edit, :update, :destroy ]
  before_action :require_admin, only: [ :destroy_all ]

  # GET /todos
  def index
    @todos = current_user.admin? ? Todo.all : current_user.todos
  end

  # GET /todos/new
  def new
    @todo = current_user.todos.build
  end

  # POST /todos
  def create
    @todo = current_user.todos.build(todo_params)
    if @todo.save
      redirect_to todos_path, notice: "Todo created successfully."
    else
      render :new
    end
  end

  # GET /todos/:id/edit
  def edit; end

  # PATCH/PUT /todos/:id
  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo updated successfully."
    else
      render :edit
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    redirect_to todos_path, notice: "Todo deleted successfully."
  end

  # DELETE /destroy_all_todos
  def destroy_all
    Todo.delete_all
    redirect_to todos_path, notice: "All todos deleted!"
  end

  private

  def set_todo
    @todo = current_user.admin? ? Todo.find(params[:id]) : current_user.todos.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :completed)
  end

  def require_admin
    redirect_to todos_path, alert: "Not authorized." unless current_user.admin?
  end
end
