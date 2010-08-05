module DbCompile
  class Trigger < Construct
    def build_path
      @path = File.join('triggers', "#{name}.sql")
    end

    def verify
      sql = nil
      case ActiveRecord::Base.connection.class.to_s
        when 'ActiveRecord::ConnectionAdapters::PostgreSQLAdapter'
          sql = "select * from pg_trigger where tgname = '#{name}';"
      end
      if sql
        result = ActiveRecord::Base.connection.execute(sql)
        return result.rows.length == 1
      end
    end
  end
end
