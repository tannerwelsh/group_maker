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

        User.find_by_name(project_lead_name).join_project(project)
      end
    end  

    desc "Build choices for each member"
    task :choices => :environment do
      ProjectChoice.delete_all if ProjectChoice.any?
      projects = Project.all

      User.all.each do |user|
        1.upto(3) do |priority|
          begin
            project = projects.sample
          end while user.project_choices.any? { |choice| choice.project == project }
          
          ProjectChoice.create(user_id: user.id, project_id: project.id, priority: priority)
        end
      end
    end

  end

end