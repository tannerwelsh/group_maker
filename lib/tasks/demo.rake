namespace :demo do
  namespace :build do
    desc "Populate the database with demo projects"
    task :projects => :environment do
      require 'csv'
      
      DEMO_PROJECTS_FILE  = File.dirname(__FILE__) + '/../assets/demo_projects.csv'

      CSV.read(DEMO_PROJECTS_FILE).each_with_index do |row, index|
        next if index == 0
        project_name, project_lead_name = row

        project = Project.create name: project_name

        User.find_by_name(project_lead_name).join_project(project)
      end
    end  
  end
end