# frozen_string_literal: true

# RecognitionsController
class RecognitionsController < ApplicationController
  helper RecognitionsHelper
  before_action :require_user, only: %i[show index new edit create update destroy]
  before_action :set_recognition, only: %i[show edit update destroy]
  before_action :authorize_editor, only: %i[edit update destroy]

  # GET /recognitions
  # GET /recognitions.json
  def index
    @recognitions = Recognition.all
  end

  # GET /feed.rss
  def feed
    @recognitions = Recognition.all.order(:created_at).reverse_order.first(15)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

  # GET /recognitions/1
  # GET /recognitions/1.json
  def show; end

  # Homepage for app
  def front; end

  # GET /recognitions/new
  def new
    @recognition = Recognition.new
  end

  # GET /recognitions/1/edit
  def edit; end

  # POST /recognitions
  # POST /recognitions.json
  # rubocop:disable Metrics/MethodLength
  def create
    @recognition = Recognition.new(recognition_params)
    @recognition.user = current_user
    respond_to do |format|
      if @recognition.save
        format.html { redirect_to @recognition, notice: 'Recognition was successfully created.' }
        format.json { render :show, status: :created, location: @recognition }
      else
        format.html { render :new }
        format.json { render json: @recognition.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /recognitions/1
  # PATCH/PUT /recognitions/1.json
  def update
    respond_to do |format|
      if @recognition.update(recognition_params)
        format.html { redirect_to @recognition, notice: 'Recognition was successfully updated.' }
        format.json { render :show, status: :ok, location: @recognition }
      else
        format.html { render :edit }
        format.json { render json: @recognition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recognitions/1
  # DELETE /recognitions/1.json
  def destroy
    @recognition.destroy
    respond_to do |format|
      format.html { redirect_to recognitions_url, notice: 'Recognition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Ensure the current user is allowed to edit/update/delete the current recognition
  def authorize_editor
    # rubocop:disable Metrics/LineLength
    redirect_to @recognition, notice: 'You are only allowed to modify your own recognitions' unless can_administrate?(@recognition)
    # rubocop:enable Metrics/LineLength
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_recognition
    @recognition = Recognition.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def recognition_params
    params.require(:recognition).permit(:employee_id, :library_value,
                                        :description, :anonymous,
                                        :recognizer)
  end
end
