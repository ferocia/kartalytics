# frozen_string_literal: true

namespace :grape do
  desc 'Condensed API Routes'
  task routes: :environment do
    mapped_prefix = '/api' # where mounted in routes.rb
    format = '%46s  %3s %7s %50s %12s:  %s'
    LeaguebotAPI.routes.each do |grape_route|
      info = grape_route.instance_variable_get :@options
      puts format % [
        info[:description] ? info[:description][0..45] : '',
        info[:version],
        info[:method],
        mapped_prefix + info[:path],
        '# params: ' + info[:params].length.to_s,
        info[:params].first.inspect
      ]
      next unless info[:params].length > 1
      info[:params].each_with_index do |param_info, index|
        next if index == 0
        puts format % ['', '', '', '', '', param_info.inspect]
      end
    end
  end
end
