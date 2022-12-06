require_relative 'F:\RubyOnRailsProjects\Stochastic_Course\app\distribution\Modules.rb'
include NeymanModule # модуль методу Неймана
include MetropolisModule # модуль методу Метрополіса
include ReverseModule # модуль методу зворотної функції
include DiagramsInfoModule # модуль методу Метрополіса
include VisualizationModule # модуль методів для гістограм
include ResultModule # модуль результатів

class ReciprocalsController < ApplicationController
  before_action :set_reciprocal, only: %i[ show edit update destroy ]

  # GET /reciprocals or /reciprocals.json
  def index
    @reciprocals = Reciprocal.all
    length = Reciprocal.all.length

    if length == 0
      alf = 1.0
      bet = 4.0
      val_n = 200.0
      n_g = 20.0
    else
      @reciprocal = Reciprocal.find(length)
      alf = @reciprocal.x.to_f
      bet = @reciprocal.y.to_f
      val_n = @reciprocal.val_n.to_f
      n_g = @reciprocal.n_g.to_f
    end

    helper_methods = helper_result(alf, bet, val_n, n_g).dig(:methods)
    helper_frequencies = helper_result(alf, bet, val_n, n_g).dig(:frequencies)

    @pdf = method_pdf(alf, bet, val_n)
    @p_k = approx_distribution_visual(alf, bet, n_g)
    @series_one_neyman = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_one_neyman))
    @series_two_neyman = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_two_neyman))
    @series_one_metropolis = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_one_metropolis))
    @series_two_metropolis = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_two_metropolis))
    @series_one_reverse = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_one_reverse))
    @series_two_reverse = series_visual(alf, bet, n_g, helper_frequencies.dig(:frequency_two_reverse))

    @average = result_average(alf, bet)
    @mode = alf
    @dispersion = result_dispersion(alf, bet)

    @average_series_one_neyman = result_average_series(helper_methods.dig(:neyman_for_first))
    @average_series_two_neyman = result_average_series(helper_methods.dig(:neyman_for_second))

    @average_series_one_metropolis = result_average_series(helper_methods.dig(:metropolis_for_first))
    @average_series_two_metropolis = result_average_series(helper_methods.dig(:metropolis_for_second))

    @average_series_one_reverse = result_average_series(helper_methods.dig(:reverse_for_first))
    @average_series_two_reverse = result_average_series(helper_methods.dig(:reverse_for_second))

    @mode_series_one_neyman = result_mode_series(helper_methods.dig(:neyman_for_first))
    @mode_series_two_neyman = result_mode_series(helper_methods.dig(:neyman_for_second))

    @mode_series_one_metropolis = result_mode_series(helper_methods.dig(:metropolis_for_first))
    @mode_series_two_metropolis = result_mode_series(helper_methods.dig(:metropolis_for_second))

    @mode_series_one_reverse = result_mode_series(helper_methods.dig(:reverse_for_first))
    @mode_series_two_reverse = result_mode_series(helper_methods.dig(:reverse_for_second))

    @dispersion_series_one_neyman = result_dispersion_series(helper_methods.dig(:neyman_for_first))
    @dispersion_series_two_neyman = result_dispersion_series(helper_methods.dig(:neyman_for_second))

    @dispersion_series_one_met = result_dispersion_series(helper_methods.dig(:metropolis_for_first))
    @dispersion_series_two_met = result_dispersion_series(helper_methods.dig(:metropolis_for_second))

    @dispersion_series_one_reverse = result_dispersion_series(helper_methods.dig(:reverse_for_first))
    @dispersion_series_two_reverse = result_dispersion_series(helper_methods.dig(:reverse_for_second))
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
        format.html { redirect_to home_url(@reciprocal)}
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
        format.html { redirect_to reciprocals_url(@reciprocal)}
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
      format.html { redirect_to reciprocals_url}
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
    params.require(:reciprocal).permit(:x, :y, :val_n, :n_g)
  end
end
