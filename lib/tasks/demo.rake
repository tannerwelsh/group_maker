namespace :demo do
  
  namespace :build do
    desc "Drop & rebuild db; populate with users, projects, choices; make groups"
    task :all => :environment do
      %w{ db:schema:load demo:build:students demo:build:projects demo:build:choices }.each do |task|
        puts "Invoking #{task}..."
        Rake::Task[task].invoke  
      end
    end

    desc "Populate the database with sample students"
    task :students => :environment do
      require 'csv'

      STUDENT_FILE = File.dirname(__FILE__) + '/../assets/students.csv'

      # Generate students
      CSV.read(STUDENT_FILE).each_with_index do |row, index|
        next if index == 0 || row.empty?
        student = User.create! name: row[0], email: row[1], password: "candybar"
        student.update_attribute(:role, "student")
      end

    end
    
    desc "Populate the database with demo projects"
    task :projects => :environment do
      raise 'No users in database' unless User.any?

      DEMO_PROJECTS_FILE  = File.dirname(__FILE__) + '/../assets/demo_projects.csv'

      require 'csv'
      CSV.read(DEMO_PROJECTS_FILE).each_with_index do |row, index|
        next if index == 0 || row.empty?
        project_name, project_lead_name = row

        creator = User.find_by_name(project_lead_name)
        project = creator.created_projects.create(name: project_name)
      end
    end  

    desc "Build choices for each member"
    task :choices => :environment do
      raise 'No users in database' unless User.any?
      raise 'No projects in database' unless Project.any?

      projects = Project.all

      User.all.each do |user|
        sample_projects = projects.dup.shuffle

        ProjectChoice::PRIORITIES.each do |priority|
          next unless user.choice(priority).nil?

          unpicked_created_projects = sample_projects & user.created_projects
          
          if user.is_creator? && !unpicked_created_projects.empty?
            project = unpicked_created_projects.sample(1).first

            sample_projects.reject! { |proj| proj.id == project.id }
          else
            project = sample_projects.pop
          end
          
          ProjectChoice.create(user_id: user.id, project_id: project.id, priority: priority)
        end
      end
    end

  end

end