module KonturFocus
  module Utils
    # expected_inns_or_orgns - массив ИНН и ОГРН, возможно в перемешку
    # это атрибуты контрагентов, которые нас интересуют
    # actual_inn_ogrn_pairs -  массив хэщей вида
    # {inn: <inn value>, ogrn: <ogrn value>}
    # это атрибуты контагентов, которые есть в Контуре
    #
    # Метод возвращает атрибуты из массива expected_inns_or_orgns, которых нет в Контуре
    def self.diff expected_inns_or_orgns, actual_inn_ogrn_pairs
      # Все приведем к одному типу int
      expected_inns_or_orgns.map(&:to_i).uniq -
        actual_inn_ogrn_pairs.map{|element| element['inn'].to_i} -
        actual_inn_ogrn_pairs.map{|element| element['ogrn'].to_i}
    end
  end
end
