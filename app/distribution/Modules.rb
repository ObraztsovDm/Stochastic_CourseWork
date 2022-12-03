module NeymanModule

  def reciprocal_neyman(x, alf, bet)
    1 / (x * Math.log(bet / alf))
    #(x ** (alf - 1)) * ((1 - x) ** (bet - 1))
  end

  def ran_rec_neyman(val_w, alf, bet, val_n)
    result_mas = []

    (0...val_n).each do
      while 1
        g_1 = rand
        g_2 = rand
        x = alf + (bet - alf) * g_1
        y = val_w * g_2

        if reciprocal_neyman(x, alf, bet) > y
          result_mas << x
          break
        end
      end
    end

    result_mas
  end

  def result_neyman(val_n, alf, bet)
    # розрахунок максимального значення W, розбитий інтервал 0,1 на N частин
    max = Float::MIN
    step = (bet - alf) / val_n

    # alf - начало цикла; bet - конец; step - шаг
    alf.step(bet, step) do |i|

      temp = reciprocal_neyman(i, alf, bet)

      if temp > max
        max = temp
      end
    end

    ran_rec_neyman(max, alf, bet, val_n)
  end
end

module MetropolisModule

  def beta_metropolis(x, alf, bet)
    1 / (x * Math.log(bet / alf))
  end

  def ran_bet_metropolis(del, x_0, alf, bet)
    x = x_0 + (-1 + 2 * rand) * del

    if x > alf and x < bet
      a = beta_metropolis(x, alf, bet) / beta_metropolis(x_0, alf, bet)
    else
      a = 0
    end

    if a >= bet
      x_0 = x
    elsif rand < a
      x_0 = x
    end

    x_0
  end

  def result_metropolis(del, x_0, alf, bet, val_n)
    step = (bet - alf) / val_n

    alf.step(bet, step) do
      ran_bet_metropolis(del, x_0, alf, bet)
    end

    ran_bet_metropolis(del, x_0, alf, bet)
  end
end

module DiagramsInfoModule
  include NeymanModule

=begin
  def rectangle_integration(alf, bet, n_g)
    sum_func = 0
    step = (bet - alf) / n_g
    (alf..bet).step(step) { |temp|
      sum_func += reciprocal_neyman(temp, alf, bet)
    }

    sum_func
  end

  def calculate_rectangle(alf, bet, n_g, sum_func)
    (bet - alf) * (sum_func / n_g)
  end

  def result_integration(alf, bet, n_g)
    temp = rectangle_integration(alf, bet, n_g)

    calculate_rectangle(alf, bet, n_g, temp)
  end
=end

  def dispersion(alf, bet)
    (((bet ** 2) - (alf ** 2)) / (2 * Math.log(bet / alf))) - (((bet - alf) / Math.log(bet / alf)) ** 2)
  end

  def func_integration(x, alf, bet)
    Math.log(x).abs / (Math.log(bet) - Math.log(alf))
  end

  def approximation_integration_pk(n_g, alf, bet)
    result = []
    temp = []
    step = (bet - alf) / n_g

    alf.step(bet, step) do |i|

      if i == bet
        break
      end

      temp << [i, i + step]
      result << (func_integration(i + step, alf, bet) - func_integration(i, alf, bet)) / ((i + step) - i)
    end

    {
      :result => result,
      :intervals => temp
    }
  end

  def calculation_pk_frequency(alf, bet, n_g, neyman_res)
    result_frequency = []
    step = (bet - alf) / n_g

    alf.step(bet, step) do |i|
      v_k = 0

      if i == bet
        break
      end

      neyman_res.each do |point|
        if point > i and point < i + step
          v_k += 1
        end
      end

      result_frequency << v_k / neyman_res.length.to_f
    end

    result_frequency
  end

  def different_series(alf, bet, n_g, pk_res)
    result_series = []
    step = (bet - alf) / n_g
    j = 0

    alf.step(bet, step) do |i|

      if i == bet
        break
      end

      result_series << pk_res[j] / ((i + step) - i)
      j += 1
    end

    result_series
  end
end

module VisualizationModule
  include NeymanModule
  include DiagramsInfoModule

  def method_pdf(alf, bet, val_n)
    step = (bet - alf) / val_n
    result = []

    alf.step(bet, step) do |i|
      x = i
      y = reciprocal_neyman(x, alf, bet)

      result << [x, y]
    end

    result
  end

  def approx_distribution_visual(alf, bet, n_g)
    step = (bet - alf) / n_g
    result = []
    j = 0

    alf.step(bet, step) do |i|

      y = approximation_integration_pk(n_g, alf, bet).dig(:result)[j]
      j += 1

      if i == bet
        break
      end

      result << ["#{i.round(2)} - #{(i + step).round(2)}", y]
    end

    result
  end

  def series_visual(alf, bet, n_g, frequency)
    step = (bet - alf) / n_g
    result = []
    j = 0

    alf.step(bet, step) do |i|

      y = different_series(alf, bet, n_g, frequency)[j]
      j += 1

      if i == bet
        break
      end

      result << ["#{i.round(2)} - #{(i + step).round(2)}", y]
    end

    result
  end

  def result_mode(result_param)
    temp = result_param[0]
    result_param.each do |i|
      if temp < i
        temp = i
      end
    end

    temp
  end
end

module ResultModule

  # математичне очікування
  def result_average(alf, bet)
    (bet - alf) / Math.log(bet / alf)
  end

  # мода
  def result_mode(alf)
    alf
  end

  # дисперсія
  def result_dispersion(alf, bet)
    (((bet ** 2) - (alf ** 2)) / (2 * Math.log(bet / alf))) - (((bet - alf) / Math.log(bet / alf)) ** 2)
  end

  # математичне очікування для серій
  def result_average_series(result_param)
    sum_for_average = 0.0

    result_param.each do |i|
      sum_for_average += i
    end

    sum_for_average / result_param.length.to_f
  end

  # мода для серій
  def result_mode_series(result_param)
    temp = result_param[0]

    result_param.each do |i|
      if temp > i
        temp = i
      end
    end

    temp
  end

  # дисперсія для серій
  def result_dispersion_series(result_param)
    temp = 0.0

    result_param.each do |i|
      temp += i ** 2
    end

    average_var_squared = temp / result_param.length

    average_square = result_average_series(result_param) ** 2

    average_var_squared - average_square
  end
end
