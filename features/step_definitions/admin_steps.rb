# Credential steps

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

# Browsing steps

Then /^I can see a selection of all letters to browse$/ do
  ("A".."Z").each do |letter| 
    page.should have_link(letter, :href => "/admin/browse/#{letter.downcase}")
  end
end

When /^I browse letter "([^"]*)"$/ do |letter|
  visit "/admin/browse/#{letter}"
end

Then /^I should see images from service$/ do |table|
  table.hashes.each { |attr| should_have_image "to_add", attr[:Image] }
end

Then /^I should see saved images$/ do |table|
  table.hashes.each { |attr| should_have_image "saved", attr[:Image] }
end

def should_have_image(category, link)
  page.should have_xpath("//div[@id='#{category}']//img[@src=\"#{link}\"]")
end

When /^I click to save image "([^"]*)"$/ do |image_id|
  click_link("image_#{image_id}")
end

# External services step (i.e. image service and DB)

Given /^an Image service with the following entries$/ do |table|
  set :image_service, FakeImageService.new(table.hashes)
end

Given /^no saved entries$/ do
  DB.collection("images").remove()
end

Given /^the following saved entries$/ do |table|
  DB.collection("images").remove()
  table.hashes.each { |image| DB.collection("images").save(image) }
end
