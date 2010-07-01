module DbCompile
  class View < Construct
    def build_path
      @path = File.join('views', "#{name}.sql")
    end

    def source
      "CREATE OR REPLACE VIEW #{name} AS #{super}"
    end
  end
end
