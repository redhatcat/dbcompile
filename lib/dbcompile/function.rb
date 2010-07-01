module DbCompile
  class Function < Construct
    def build_path
      @path = File.join('functions', "#{name}.sql")
    end
  end
end
