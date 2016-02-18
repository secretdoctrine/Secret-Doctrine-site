# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "FeedbackEntries" do
    describe "Admin" do
      describe "feedback_entries", type: :feature do
        refinery_login

        describe "feedback_entries list" do
          before do
            FactoryGirl.create(:feedback_entry, :poster_name => "UniqueTitleOne")
            FactoryGirl.create(:feedback_entry, :poster_name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.feedback_entries_admin_feedback_entries_path
            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.feedback_entries_admin_feedback_entries_path

            click_link "Add New Feedback Entry"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Poster Name", :with => "This is a test of the first string field"
              expect { click_button "Save" }.to change(Refinery::FeedbackEntries::FeedbackEntry, :count).from(0).to(1)

              expect(page).to have_content("'This is a test of the first string field' was successfully added.")
            end
          end

          context "invalid data" do
            it "should fail" do
              expect { click_button "Save" }.not_to change(Refinery::FeedbackEntries::FeedbackEntry, :count)

              expect(page).to have_content("Poster Name can't be blank")
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:feedback_entry, :poster_name => "UniqueTitle") }

            it "should fail" do
              visit refinery.feedback_entries_admin_feedback_entries_path

              click_link "Add New Feedback Entry"

              fill_in "Poster Name", :with => "UniqueTitle"
              expect { click_button "Save" }.not_to change(Refinery::FeedbackEntries::FeedbackEntry, :count)

              expect(page).to have_content("There were problems")
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:feedback_entry, :poster_name => "A poster_name") }

          it "should succeed" do
            visit refinery.feedback_entries_admin_feedback_entries_path

            within ".actions" do
              click_link "Edit this feedback entry"
            end

            fill_in "Poster Name", :with => "A different poster_name"
            click_button "Save"

            expect(page).to have_content("'A different poster_name' was successfully updated.")
            expect(page).not_to have_content("A poster_name")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:feedback_entry, :poster_name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.feedback_entries_admin_feedback_entries_path

            click_link "Remove this feedback entry forever"

            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
            expect(Refinery::FeedbackEntries::FeedbackEntry.count).to eq(0)
          end
        end

      end
    end
  end
end
