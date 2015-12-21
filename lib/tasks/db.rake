desc "Backup database"
namespace :radiodb do
  task backup: :environment do
    settings = YAML.load(File.read(File.join(Rails.root, "config", "database.yml")))[Rails.env]
    dump_sql_path = Pathname.new( File.join(Rails.root, "db", "backups", "#{settings['database']}-#{Time.now.strftime('%Y%m%d%H%M%S')}.sql") )

    FileUtils.mkdir_p( dump_sql_path.dirname ) unless Dir.exists?( dump_sql_path.dirname )
    system("/usr/bin/env mysqldump -h #{settings['host']} -u #{settings['username']} -p#{settings['password']} #{settings['database']} > #{dump_sql_path}")

    Zlib::GzipWriter.open("#{dump_sql_path}.gz") do |gz|
      gz.mtime = File.mtime(dump_sql_path)
      gz.orig_name = dump_sql_path.to_s
      gz.write IO.binread(dump_sql_path.to_s)
    end

    File.delete( dump_sql_path )

  end
end