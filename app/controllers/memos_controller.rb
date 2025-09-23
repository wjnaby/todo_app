class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [ :show, :edit, :update, :destroy ]

  def index
    @memos = current_user.memos.order(created_at: :desc)
  end

  def show
  end

  def new
    @memo = current_user.memos.build
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to @memo, notice: "Memo created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @memo.update(memo_params)
      redirect_to @memo, notice: "Memo updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memo.destroy
    redirect_to memos_path, notice: "Memo deleted."
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:title, :content)
  end
end
