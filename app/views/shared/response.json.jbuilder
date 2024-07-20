json.message @message
json.ok @ok.nil? ? true : @ok
json.data @data.nil? ? nil : @data
json.details @details.nil? ? [] : @details
