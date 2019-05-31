# frozen_string_literal: true

module Resources
  class Slack < Grape::API
    format :json

    params do
      requires :token, type: String
      requires :text, type: String
    end
    post do
      SlackParser.new(params).execute
    end
  end
end
