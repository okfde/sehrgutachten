namespace :papers do
  desc 'switch logger to stdout'
  task to_stdout: :environment do
    Rails.logger = Logger.new(STDOUT)
  end

  desc 'Import new papers'
  task :import_new, [:department] => [:environment] do |_t, args|
    department = Department.find_by_short_name(args[:department])
    Rails.logger.info "Adding job for importing new papers [#{department.short_name}]"
    ImportNewPapersJob.perform_now(department)
  end
end
