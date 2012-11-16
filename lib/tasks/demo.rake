namespace :demo do
  
  namespace :build do
    desc "Drop and build everything"
    task :all => :environment do
      %w{ db:drop db:migrate db:seed demo:build:projects demo:build:choices }.each do |task|
        puts "Invoking #{task}..."
        Rake::Task[task].invoke  
      end

      Project.make_groups!
    end
    
    desc "Populate the database with demo projects"
    task :projects => :environment do
      require 'csv'
      
      DEMO_PROJECTS_FILE  = File.dirname(__FILE__) + '/../assets/demo_projects.csv'

      CSV.read(DEMO_PROJECTS_FILE).each_with_index do |row, index|
        next if index == 0
        project_name, project_lead_name = row

        project = Project.create(name: project_name)
        lead    = User.find_by_name(project_lead_name)

        lead.join_project(project)
        lead.choices.create(project_id: project.id, priority: 1)
      end
    end  

    desc "Build choices for each member"
    task :choices => :environment do
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