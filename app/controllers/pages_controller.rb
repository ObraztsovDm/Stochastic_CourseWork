class PagesController < ApplicationController
  def about # вызывает шаблон views/pages/about.html.erb
    @heading = 'Сторінка про нас!' # переменная вывода информации
  end

  def help

  end
end
