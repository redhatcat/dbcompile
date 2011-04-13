module DbCompile
  class View < Construct
    def build_path
      @path = File.join('views', "#{name}.sql")
    end

    def source
      case ActiveRecord::Base.connection.class.to_s
      when "ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter"
        "CREATE OR REPLACE VIEW #{name} AS #{super}"        
      else
        "DROP VIEW IF EXISTS #{name} CASCADE; CREATE VIEW #{name} AS #{super}"
      end
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
      when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
        sql = "SELECT viewname FROM pg_catalog.pg_views WHERE viewname = '#{name}'"
      when "ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter"
        sql = "SELECT lower(view_name) FROM user_views WHERE lower(view_name) = lower('#{name}')"
      else
        raise "data dictionary query for adapter #{ActiveRecord::Base.connection.class.to_s} not defined"
      end
      require 'ckuru-tools'
      ckebug 0, sql
      return does_one_exist?(sql)
    end
  end
end
