module KonturFocus
  module DataHelper
    def read_data file_name
      JSON.parse(File.read "spec/data/#{file_name}").first
    end
  end
end
