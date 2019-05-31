# frozen_string_literal: true

class KartalyticsRaceSnapshot < ApplicationRecord
  belongs_to :race, class_name: 'KartalyticsRace', foreign_key: 'kartalytics_race_id'

  def self.series_for(player)
    wanted_attributes = [
      "#{player}_position",
      "#{player}_item",
      "timestamp"
    ]

    # Grab the elements out this way as a standard race has >600 snapshots.
    # ActiveRecord object instantiation time vs pluck is 4x slower.
    series = all.order("timestamp ASC").limit(2000).pluck(*wanted_attributes).map{|position, item, timestamp|
      {
        position: position,
        item: item,
        timestamp: timestamp
      }
    }

    # We want to null items whereby:
    #   - We haven't detected an item two frames in a row
    #   - We don't want to pick up the same item in a row unless more than ~10 frames have passed
    current_item = nil
    nil_count = 0
    series.each_with_index do |snapshot, index|
      # If we couldn't get a position, peek ahead to see if we can get one.
      if snapshot[:position].nil?
        snapshot[:position] = series[index..-1].detect{|s| s[:position] }.try(:[], :position)
      end

      # We have no line to draw on - no point running item code
      next if snapshot[:position].nil?

      if snapshot[:item].nil?
        nil_count += 1
        # We haven't detected an item in 10 frames
        # assuming the player picks up the same
        # item again we should draw it
        current_item = nil if nil_count > 10

        next
      else
        nil_count = 0
      end

      if snapshot[:item] == current_item
        # We have already "charted" this item - don't chart it twice
        snapshot[:item] = nil
      else
        # We only want to track an item if it's appeared twice in a row
        if !snapshot.equal?(series.last) && series[index + 1][:item] == snapshot[:item]
          current_item = snapshot[:item]
        else
          snapshot[:item] = nil
        end
      end
    end

    # Finally if we couldn't get a position, reject those items
    series.reject{|s|
      s[:position].nil?
    }
  end
end
