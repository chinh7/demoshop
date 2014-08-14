APP_ROOT = File.expand_path(File.dirname(File.dirname(__FILE__)), "../../current")
working_directory APP_ROOT
worker_processes 2
timeout 60
preload_app true
listen "/tmp/merchant_unicorn.sock", :backlog => 64
pid APP_ROOT + "/tmp/pids/merchant_unicorn.pid"
stderr_path APP_ROOT + "/log/merchant_unicorn.stderr.log"
stdout_path APP_ROOT + "/log/merchant_unicorn.stdout.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  old_pid = Rails.root + 'tmp/pids/merchant_unicorn.pid.oldbin'
  Rails.logger.warn("[UNICORN] old_pid=#{old_pid}")
  Rails.logger.warn("[UNICORN] server.pid=#{server.pid}")
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Rails.logger.warn("[UNICORN] Sending QUIT to old_pid #{File.read(old_pid)}")
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      Rails.logger.warn("[UNICORN] Cannot quit old master")
    end
  else
    Rails.logger.warn("[UNICORN] Old pid not found")
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
  child_pid = server.config[:pid].sub('.pid', ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end

before_exec do |server|
  # Make sure new gems will be loaded on hot reload
  ENV['BUNDLE_GEMFILE'] = "#{APP_ROOT}/Gemfile"
end
