require 'spec_helper'
require 'rake'

describe GroupList do
  let(:list) { GroupList.new }

  describe '.generate!' do
    it "adds members to the appropriate amount of projects" do
      num_projects = (User.count / GROUP_SIZE)
      top_projects = Project.sorted_by_popularity[0...num_projects]
      
      GroupList.generate!

      top_projects.each do |project|
        project.group_size.should be_close(GROUP_SIZE, 1)
      end
    end
  end  

end