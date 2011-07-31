When /^I visit the admin page with the wrong admin credentials$/ do
  visit "/admin"
  page.driver.browser.basic_authorize("wrong", "wrong")
end

When /^I visit the admin page with the admin credentials$/ do
  page.driver.browser.basic_authorize("admin", "Demo123")
  visit "/admin"
end

Then /^I am not allowed to enter the admin area$/ do
  page.should have_content "Access Denied"
end

Then /^I can see a selection of all letters to browse$/ do
  ("A".."Z").each do |letter| 
    page.should have_link(letter, :href => "/admin/browse/#{letter.downcase}")
  end
end
