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

    def execute
      @run_queue.each{ |construct_name, object_name|
        klass = "DbCompile::#{construct_name.singularize.camelize}".constantize
        construct = klass.new(object_name, @path)
        puts "Compiling #{construct.path}"
        Rails.logger.info "Compiling #{construct.path}"
        construct.execute
      }
    end
  end
end
