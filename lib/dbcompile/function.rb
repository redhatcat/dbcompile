module DbCompile
  class Function < Construct
    def build_path
      @path = File.join('functions', "#{name}.sql")
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "SELECT proname FROM pg_proc WHERE proname = '#{name.downcase}';"
      end
      if sql
        result = ActiveRecord::Base.connection.execute(sql)
        return result.length == 1
      end
    end
  end
end
