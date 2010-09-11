module DbCompile
  class View < Construct
    def build_path
      @path = File.join('views', "#{name}.sql")
    end

    def source
      "DROP VIEW IF EXISTS #{name} CASCADE; CREATE VIEW #{name} AS #{super}"
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "SELECT viewname FROM pg_catalog.pg_views WHERE viewname = '#{name}'"
      end
      if sql
        result = ActiveRecord::Base.connection.execute(sql)
        return result.count == 1
      end
    end
  end
end
