require 'dbcompile/construct.rb'
require 'dbcompile/function.rb'
require 'dbcompile/trigger.rb'
require 'dbcompile/view.rb'

module DbCompile
  class CircularDependenciesException < Exception; end

  # Encapsulates entire transaction and dependency checking
  class Transaction
    def initialize(path)
      @run_queue = []
      @deps_queue = []
      @manifest_path = File.join(path, 'dbcompile.yml')
      @manifest = YAML::load_file(@manifest_path)

      @manifest.each{ |construct_name, data|
        if data
          data.each{ |object_name, dependencies|
            install_dependencies(construct_name, object_name)
          }
        end
      }
      puts @run_queue.inspect
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

    def run
      #klass = "DbCompile::#{construct_name.singularize.camelize}".constantize
    end
  end
end
