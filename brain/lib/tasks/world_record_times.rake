# frozen_string_literal: true

namespace :courses do
  desc 'Update world record times in database'

  task update_world_records: :environment do
    puts "Retrieving new course world records"
    ProcessWorldRecordsCommand.new.run
  end
end