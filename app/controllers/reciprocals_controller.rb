require_relative 'F:\RubyOnRailsProjects\test_app_course\app\distribution\Modules.rb'
include NeymanModule # модуль методу Неймана
include DiagramsInfoModule # модуль методу Метрополіса
include VisualizationModule # модуль методів для гістограм
include ResultModule # модуль результатів

class ReciprocalsController < ApplicationController
  before_action :set_reciprocal, only: %i[ show edit update destroy ]

  # GET /reciprocals or /reciprocals.json
  def index
    #@reciprocals = nil
    alf = 2.0
    bet = 6.0
    val_n = 20000.0
    n_g = 20.0

    neyman_for_first = result_neyman(val_n, alf, bet)
    neyman_for_second = result_neyman(val_n, alf, bet)
    frequency_one = calculation_pk_frequency(alf, bet, n_g, neyman_for_first)
    frequency_two = calculation_pk_frequency(alf, bet, n_g, neyman_for_second)

    @pdf = method_pdf(alf, bet, val_n)
    @p_k = approx_distribution_visual(alf, bet, n_g)
    @series_one = series_visual(alf, bet, n_g, frequency_one)
    @series_two = series_visual(alf, bet, n_g, frequency_two)

    @average = result_average(alf, bet)
    @mode = result_mode(alf)
    @dispersion = result_dispersion(alf, bet)

    @average_series_one = result_average_series(neyman_for_first)
    @average_series_two = result_average_series(neyman_for_second)

    @mode_series_one = result_mode_series(neyman_for_first)
    @mode_series_two = result_mode_series(neyman_for_second)

    @dispersion_series_one = result_dispersion_series(neyman_for_first)
    @dispersion_series_two = result_dispersion_series(neyman_for_second)
    #@reciprocals = Reciprocal.all
  end

  # GET /reciprocals/1 or /reciprocals/1.json
  def show
  end

  # GET /reciprocals/new
  def new
    @reciprocal = Reciprocal.new
  end

  # GET /reciprocals/1/edit
  def edit
  end

  # POST /reciprocals or /reciprocals.json
  def create
    @reciprocal = Reciprocal.new(reciprocal_params)

    respond_to do |format|
      if @reciprocal.save
        format.html { redirect_to reciprocal_url(@reciprocal), notice: "Reciprocal was successfully created." }
        format.json { render :show, status: :created, location: @reciprocal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reciprocal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reciprocals/1 or /reciprocals/1.json
  def update
    respond_to do |format|
      if @reciprocal.update(reciprocal_params)
        format.html { redirect_to reciprocal_url(@reciprocal), notice: "Reciprocal was successfully updated." }
        format.json { render :show, status: :ok, location: @reciprocal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reciprocal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reciprocals/1 or /reciprocals/1.json
  def destroy
    @reciprocal.destroy

    respond_to do |format|
      format.html { redirect_to reciprocals_url, notice: "Reciprocal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reciprocal
      @reciprocal = Reciprocal.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reciprocal_params
      params.require(:reciprocal).permit(:x, :y)
    end
end
