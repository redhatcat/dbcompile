require 'dbcompile/construct.rb'
require 'dbcompile/function.rb'
require 'dbcompile/trigger.rb'
require 'dbcompile/view.rb'

module DbCompile
  class CircularDependenciesException < Exception; end

  # Encapsulates entire transaction and dependency checking
  class Transaction
    def initialize(path)
      @path = path
      @run_queue = []
      @deps_queue = []
      @manifest = YAML::load_file(File.join(path, 'compile.yml'))

      @manifest.each{ |construct_name, data|
        if data
          data.each{ |object_name, dependencies|
            install_dependencies(construct_name, object_name)
          }
        end
      }
    end

    def install_dependencies(construct_name, object_name)
      if @deps_queue.include? [construct_name, object_name]
        raise CircularDependenciesException.new(
          "Dependency of #{construct_name} #{object_name} referenced it as a dependency!")
      end
      @deps_queue << [construct_name, object_name]
      if not @run_queue.include? [construct_name, object_name]
        dependencies = @manifest[construct_name][object_name]
        if dependencies
          dependencies.each{ |dep_construct_name, name_list|
            name_list.each{ |dep_object_name|
              install_dependencies(dep_construct_name, dep_object_name)
            }
          }
        end
        @run_queue << [construct_name, object_name]
      end
      @deps_queue.pop
    end

    def build_contruct(construct_name, object_name)
      klass = "DbCompile::#{construct_name.singularize.camelize}".constantize
      klass.new(object_name, @path)
    end

    def execute
      @run_queue.each{ |construct_name, object_name|
        construct = build_contruct(construct_name, object_name)
        msg = "Compiling #{construct.path}"
        puts msg
        ActiveRecord::Base.logger.info msg
        construct.execute
      }
    end

    def verify
      msg = "Verifying compilation"
      puts msg
      ActiveRecord::Base.logger.info msg
      @run_queue.each{ |construct_name, object_name|
        construct = build_contruct(construct_name, object_name)
        case construct.verify
          when nil
            msg = "#{construct_name.capitalize} #{object_name} could not be verified."
          when true
            msg = "#{construct_name.capitalize} #{object_name} successfully created."
          when false
            msg = "#{construct_name.capitalize} #{object_name} creation failed."
        end
        puts msg
        ActiveRecord::Base.logger.info msg
      }
    end
  end
end
