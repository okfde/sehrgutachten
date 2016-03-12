namespace :departments do
  desc 'switch logger to stdout'
  task to_stdout: :environment do
    Rails.logger = Logger.new(STDOUT)
  end

  desc 'Import new departments'
  task import_new: :environment do
    Rails.logger.info "Adding job for importing new departments"
    ImportNewDepartmentsJob.perform_later
  end
end
