module DbCompile
  class Trigger < Construct
    def build_path
      @path = File.join('triggers', "#{name}.sql")
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "SELECT * FROM pg_trigger WHERE tgname = '#{name}';"
      end
      if sql
        result = ActiveRecord::Base.connection.execute(sql)
        return result.length == 1
      end
    end
  end
end
