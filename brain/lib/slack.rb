# frozen_string_literal: true

# TODO: capture logged in user *league* settings
#       - slack_notification_hook_url
#       - slack_notification_channel
#       - slack_notification_user -> default to 'kartbot-result'
#       - slack_notification_user_emoji
class Slack
  # Send notification to slack directly
  # Requires incoming webhook to be created

  def self.notify(leaderboard_body)
    slack_notification_hook_url   = ENV.fetch('SLACK_HOOK_URL')
    slack_notification_channel    = '#kartistics'
    slack_notification_user       = 'kartbot-result-notification'
    slack_notification_user_emoji = ':leaderseeker:'

    params = {
      channel:    slack_notification_channel,
      username:   slack_notification_user,
      icon_emoji: slack_notification_user_emoji,
      text:       "\n```\n#{leaderboard_body}\n```"
    }
    Rails.logger.info "Notifying: #{slack_notification_hook_url} with:\n #{params}"

    uri = URI.parse(slack_notification_hook_url)
    request = Net::HTTP::Post.new(uri.path)
    request.body = params.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.ssl_version = :SSLv3
      http.request request
    end

    Rails.logger.info "Notification response: #{response.body}"
  end
end
