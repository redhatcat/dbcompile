module DbCompile
  class Trigger < Construct
    def build_path
      @path = File.join('triggers', "#{name}.sql")
    end
  end
end
