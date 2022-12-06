module NeymanModule

  def reciprocal(x, alf, bet)
    1 / (x * Math.log(bet / alf)) # функція щільності ймовірності
  end

  def ran_rec_neyman(val_w, alf, bet, val_n)
    result_mas = []

    (0...val_n).each do
      while 1
        # перший крок
        g_1 = rand
        g_2 = rand
        # другий крок
        x = alf + (bet - alf) * g_1
        y = val_w * g_2

        # третій крок
        if reciprocal(x, alf, bet) > y
          result_mas << x
          break
        end
      end
    end

    # результат
    result_mas
  end

  def result_neyman(val_n, alf, bet)
    max = Float::MIN
    step = (bet - alf) / val_n

    # розрахунок максимального значення W
    alf.step(bet, step) do |i|
      temp = reciprocal(i, alf, bet)

      if temp > max
        max = temp
      end
    end

    ran_rec_neyman(max, alf, bet, val_n)
  end
end

module MetropolisModule
  include NeymanModule

  def ran_rec_metropolis(alf, bet, val_n)
    result = []

    # випадкове значення x_0 з якого стартує алгоритм
    x_0 = alf + (bet - alf) * rand

    del = (bet - alf) / 3.0

    (0...val_n).each do
      # випадкове значення x
      x = x_0 + (-1 + 2 * rand) * del

      # визначення а
      if x >= alf and x <= bet
        a = reciprocal(x, alf, bet) / reciprocal(x_0, alf, bet)
      else
        a = 0
      end

      # обирання випадкового значення x_0
      if a > 1
        x_0 = x
      elsif rand < a
        x_0 = x
      end

      # запис знечень до масиву
      result << x_0
    end

    # результат
    result
  end
end

module ReverseModule
  include NeymanModule

  def func_reverse(alf, bet)
    alf * ((bet / alf) ** rand) # (ln(x) - ln(a)) / (ln(b) - ln(a)) = y; x = a * ((b / a)^y)
  end

  def result_reverse(alf, bet, val_n)
    result = []

    (0...val_n).each do
      while 1
        temp = func_reverse(alf, bet)

        # перевірка потряпляння в проміжок
        if temp >= alf and temp <= bet
          result << temp
          break
        end
      end
    end

    result
  end
end

module DiagramsInfoModule
  include NeymanModule
  include MetropolisModule

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

  def calculation_pk_frequency(alf, bet, n_g, res_method)
    result_frequency = []
    step = (bet - alf) / n_g

    alf.step(bet, step) do |i|
      v_k = 0

      if i == bet
        break
      end

      res_method.each do |point|
        if point > i and point < i + step
          v_k += 1
        end
      end

      result_frequency << v_k / res_method.length.to_f
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
  include MetropolisModule
  include DiagramsInfoModule

  def method_pdf(alf, bet, val_n)
    step = (bet - alf) / val_n
    result = []

    alf.step(bet, step) do |i|
      x = i
      y = reciprocal(x, alf, bet)

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
end

module ResultModule
  include NeymanModule
  include MetropolisModule
  include ReverseModule

  # математичне очікування
  def result_average(alf, bet)
    (bet - alf) / Math.log(bet / alf)
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
=begin
  def result_mode_series(result_param)
    temp = result_param[0]

    result_param.each do |i|
      if temp > i
        temp = i
      end
    end

    temp
  end
=end

  def result_mode_series(result_param)
    result = {}

    result_param.each do |word|
      result[word.round(3)] ||= 0
      result[word.round(3)] += 1
    end
    temp = result.size - 1

    result.sort_by { |key, value| value }[temp][0]
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

  def helper_result(alf, bet, val_n, n_g)
    helper_result_methods = {
      :neyman_for_first => result_neyman(val_n, alf, bet),
      :neyman_for_second => result_neyman(val_n, alf, bet),
      :metropolis_for_first => ran_rec_metropolis(alf, bet, val_n),
      :metropolis_for_second => ran_rec_metropolis(alf, bet, val_n),
      :reverse_for_first => result_reverse(alf, bet, val_n),
      :reverse_for_second => result_reverse(alf, bet, val_n)
    }

    helper_result_frequency = {
      :frequency_one_neyman => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:neyman_for_first)),
      :frequency_two_neyman => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:neyman_for_second)),
      :frequency_one_metropolis => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:metropolis_for_first)),
      :frequency_two_metropolis => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:metropolis_for_second)),
      :frequency_one_reverse => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:reverse_for_first)),
      :frequency_two_reverse => calculation_pk_frequency(alf, bet, n_g, helper_result_methods.dig(:reverse_for_second))
    }

    {
      :methods => helper_result_methods,
      :frequencies => helper_result_frequency
    }
  end
end
