class CodesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_code, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  def index
    @codes = Code.all
    respond_with(@codes)
  end

  def show
    respond_with(@code)
  end

  def new
    @code = Code.new
    respond_with(@code)
  end

  def edit
  end

  def create
    @code = Code.new(code_params)
    @code.save
    respond_with(@code)

    # added because I didn't have the respond_to in the header
    # respond_to do |format|
    #   if @code.save
    #     format.html { redirect_to @code, notice: 'Code was successfully created.' }
    #     format.json { render :show, status: :created, location: @code }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @code.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update
    @code.update(code_params)
    respond_with(@code)
  end

  def destroy
    @code.destroy
    respond_with(@code)
  end

  private
    def set_code
      @code = Code.find(params[:id])
    end

    def code_params
      params[:code].permit(:code_type, :code_key, :code_value)
    end
end
