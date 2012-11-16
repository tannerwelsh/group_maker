namespace :demo do
  
  namespace :build do
    
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

      User.includes(:choices).each do |user|
        1.upto(3) do |priority|
          next unless user.choice(priority).nil?

          begin
            project = projects.sample
          end while user.choices.any? { |choice| choice.project == project }
          
          ProjectChoice.create(user_id: user.id, project_id: project.id, priority: priority)
        end
      end
    end

  end

end