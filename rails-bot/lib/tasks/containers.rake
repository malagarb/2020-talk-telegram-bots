namespace :containers do

  namespace :pdb do
    desc "create postgresql called pdb"
    task run: :environment do
      `docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=secret --name bot-db postgres:12.1`
    end
    desc "restart postgresql called bot-db"
    task restart: :environment do
      `docker restart bot-db`
    end
    desc "stop postgresql called bot-db"
    task stop: :environment do
      `docker stop bot-db`
    end
  end

  namespace :nginx do
    desc "create nginx called bot-proxy"
    task build: :environment do

    end
    desc "restart postgresql called bot-proxy"
    task run: :environment do

    end
    desc "restart postgresql called bot-proxy"
    task restart: :environment do
      `docker restart bot-proxy`
    end
    desc "stop postgresql called bot-proxy"
    task stop: :environment do
      `docker stop pdb`
    end
  end


end
