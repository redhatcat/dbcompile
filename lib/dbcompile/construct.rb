module DbCompile
  # Anything that can be expressed in SQL
  class Construct
    attr_accessor :name
    attr_accessor :path
    attr_accessor :root_path
    attr_accessor :dependencies

    def initialize(name, root_path)
      @name = name
      @root_path = root_path
      build_path
    end

    # Override this to set path the SQL source
    def build_path
    end

    # Execute the source to create contruct in database
    def execute
      ActiveRecord::Base.connection.execute(source)
    end

    # Return the SQL source.  Do any magic wrapping here.
    def source
      f = File.open(File.join(root_path, path))
      data = f.read
      f.close
      data
    end

    # Override to verify the existence of the construct
    # Return true for verified successs
    # Return false for verified failure
    # Return nil otherwise
    def verify
    end
  end
end
