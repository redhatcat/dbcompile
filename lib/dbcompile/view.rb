module DbCompile
  class View < Construct
    def build_path
      @path = File.join('views', "#{name}.sql")
    end

    def read
      source = super
      "CREATE OR REPLACE VIEW #{name} AS #{source}"
    end
  end
end
