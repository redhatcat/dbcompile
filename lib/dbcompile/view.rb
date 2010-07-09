module DbCompile
  class View < Construct
    def build_path
      @path = File.join('views', "#{name}.sql")
    end

    def source
      "DROP VIEW IF EXISTS #{name} CASCADE; CREATE VIEW #{name} AS #{super}"
    end
  end
end
