class HerokuDeployer
  APPS = { staging: "projectfirstgen-staging", production: "projectfirstgen" }

  def self.deploy app_env
    new(app_env).deploy
  end

  def initialize app_env
    @app_env = app_env
  end

  def deploy
    push
    migrate
  end

  private
  attr_reader :app_env

  def push
    puts 'Deploying site to Heroku ...'
    puts "git push #{app_env} master"
    puts `git push #{app_env} master`
  end

  def migrate
    puts 'Running database migrations ...'
    Bundler.with_clean_env { puts `heroku run rake db:migrate --app #{app_name}` }
  end

  def app_name
    APPS[app_env]
  end
end
