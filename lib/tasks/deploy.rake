require_relative "../heroku_deployer"

namespace :deploy do
  task :staging do
    HerokuDeployer.deploy(:staging)
  end

  task :production do
    HerokuDeployer.deploy(:production)
  end
end
