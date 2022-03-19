require "rails_helper"

RSpec.describe Project, type: :model do
  context "validations tests" do
    it "ensures the title is present" do
      project = Project.new(description: "Content of the description")
      expect(project.valid?).to eq(false)
    end

    it "ensures the description is present" do
      project = Project.new(title: "Title")
      expect(project.valid?).to eq(false)
    end
    
    it "should be able to save project" do
      project = Project.new(title: "Title", description: "Some description content goes here")
      expect(project.save).to eq(true)
    end
  end

  context "scopes tests" do
    let(:params) { { title: "Title", description: "some description" } }
    before(:each) do
      Project.create(params)
      Project.create(params)
      Project.create(params)
    end

    it "should return all projects" do
      expect(Project.count).to eq(3)
    end

  end
end

RSpec.describe ProjectsController, type: :controller do
    context "GET #index" do
      it "returns a success response" do
        get :index
        # expect(response.success).to eq(true)
        expect(response).to be_success
      end
    end
  
    context "GET #show" do
      let!(:project) { Project.create(title: "Test title", description: "Test description") }
      it "returns a success response" do
        get :show, params: { id: project }
        expect(response).to be_success
      end
    end
  end

  RSpec.feature "Visiting the homepage", type: :feature do
    scenario "The visitor should see projects" do
      visit root_path
      expect(page).to have_text("Projects")
    end
  end

  RSpec.feature "Projects", type: :feature do
    context "Create new project" do
      before(:each) do
        visit new_project_path
        within("form") do
          fill_in "Title", with: "Test title"
        end
      end
  
      scenario "should be successful" do
        fill_in "Description", with: "Test description"
        click_button "Create Project"
        expect(page).to have_content("Project was successfully created")
      end
  
      scenario "should fail" do
        click_button "Create Project"
        expect(page).to have_content("Description can't be blank")
      end
    end
  
    context "Update project" do
      let(:project) { Project.create(title: "Test title", description: "Test content") }
      before(:each) do
        visit edit_project_path(project)
      end
  
      scenario "should be successful" do
        within("form") do
          fill_in "Description", with: "New description content"
        end
        click_button "Update Project"
        expect(page).to have_content("Project was successfully updated")
      end
  
      scenario "should fail" do
        within("form") do
          fill_in "Description", with: ""
        end
        click_button "Update Project"
        expect(page).to have_content("Description can't be blank")
      end
    end
  
    context "Remove existing project" do
      let!(:project) { Project.create(title: "Test title", description: "Test content") }
      scenario "remove project" do
        visit projects_path
        click_link "Destroy"
        expect(page).to have_content("Project was successfully destroyed")
        expect(Project.count).to eq(0)
      end
    end
  end