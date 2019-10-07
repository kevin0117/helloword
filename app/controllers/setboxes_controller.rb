class SetboxesController < ApplicationController
  # protect_from_forgery with: :null_session, only: [:json]
  # 錯誤的方法 下面的才是對的
  skip_before_action :verify_authenticity_token

  before_action :find_setbox, only: [:show, :edit, :update]
  before_action :check_login, only: [:new, :create, :edit, :update, :destroy]

  def index
    @setbox = Setbox.all
    @setboxes = Setbox.joins(:cards).includes(:cards).search(params[:search]).sample(9)
  end

  def new
    @setbox = Setbox.new
  end

  def create
    @setbox = current_user.setboxes.build(setbox_params)
    
    if @setbox.save
      redirect_to home_setboxes_path, notice: "新增setbox成功" 
    else
      render :new, notice: "error"
    end
  end

  def json
    render json:{message: 'ok', token: "#{params[:answer]}"}, stauts:200
    # respond_to do |format|
    #   format.html
    #   format.json { render json: { test: 123 } }
    # end
  end

  def show
  end

  def edit
  end

  def update
    if @setbox.update(setbox_params)
      redirect_to home_setboxes_path, notice: "更新setbox成功"
    else
      render :edit
    end
  end

  def copy
    @setbox = Setbox.find_by(id: params[:id])
    # dup_setbox=Setbox.find(6).dup
    # current_user.id
    @dup_setbox = @setbox.dup
    @dup_setbox.save
    @setbox.cards.each do |card|
    # dup_card=Card.find(71).dup
    dup_card = card.dup
    # dup_card.update(setbox_id:10)
    dup_card.setbox_id = Setbox.last.id #也是 Setbox.last.id
    dup_card.save
    # debugger
    @dup_setbox.user_id = current_user.id
    @dup_setbox.save
    # debugger
    end
    
    redirect_to home_setboxes_path, notice: "複製 #{@setbox.title}成功"
  end
  
  def destroy
    @setbox = Setbox.find_by(id: params[:id])
    @setbox.destroy
    redirect_to home_setboxes_path, notice: "刪除資料"
  end

  def home
    @setbox = current_user.setboxes
  end

  def search
    @setboxes = Setbox.joins(:cards).includes(:cards).search(params[:search]).sample(9)
  end

  def pullreq
    @setboxes = Setbox.joins(:cards).includes(:cards).sample(1)
  end

  def write
    @setboxes = Setbox.joins(:cards).includes(:cards).write(params[:write]).sample(1)
    
    # if params[:write] == card_def
    #   redirect_to pullreq_setboxes_path, notice: "完全正確！"
    # else
    #   redirect_to write_setboxes_path, notice: "再試一次！"
    # end
  end

  private

  def setbox_params
    setbox_clean_params = params.require(:setbox).permit(:title, cards_attributes: [:id, :card_word, :card_def ,:_destroy])
  end

  def find_setbox
    @setbox = Setbox.find_by(id: params[:id])
  end

  def check_login
    unless user_signed_in?
      redirect_to new_user_session_path, notice: '請先登入會員'
    end
  end
end
