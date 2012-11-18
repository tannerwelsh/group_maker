namespace :demo do
  
  namespace :build do
    desc "Drop & rebuild db; populate with users, projects, choices; make groups"
    task :all => :environment do
      %w{ db:drop db:migrate db:seed demo:build:projects demo:build:choices }.each do |task|
        puts "Invoking #{task}..."
        Rake::Task[task].invoke  
      end
    end
    
    desc "Populate the database with demo projects"
    task :projects => :environment do
      raise 'No users in database' unless User.any?

      DEMO_PROJECTS_FILE  = File.dirname(__FILE__) + '/../assets/demo_projects.csv'

      require 'csv'
      CSV.read(DEMO_PROJECTS_FILE).each_with_index do |row, index|
        next if index == 0
        project_name, project_lead_name = row

        creator = User.find_by_name(project_lead_name)
        project = creator.created_projects.create(name: project_name)
        
        creator.join_project(project)
        creator.choices.create(project_id: project.id, priority: 1)
      end
    end  

    desc "Build choices for each member"
    task :choices => :environment do
      raise 'No users in database' unless User.any?
      raise 'No projects in database' unless Project.any?

      projects = Project.all

      User.all.each do |user|
        1.upto(3) do |priority|
          next if user.choices.map(&:priority).include? priority

          begin
            project = projects.sample
          end until user.choices.all? { |choice| choice.project.id != project.id }
          
          ProjectChoice.create(user_id: user.id, project_id: project.id, priority: priority)
        end
      end
    end

  end

end