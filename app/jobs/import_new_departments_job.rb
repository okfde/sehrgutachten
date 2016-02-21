class ImportNewDepartmentsJob < ApplicationJob

  def perform
    departments = WdAusarbeitungenScraper.scrape_departments

    old_departments = 0
    new_departments = 0
    departments.each do |department|
      if Department.where(short_name: department[:short_name]).exists?
        old_departments += 1
        next
      end

      Department.create(department)
      new_departments += 1
    end

    logger.info "Importing done. #{new_departments} new Departments, #{old_departments} old Departments."
  end
end