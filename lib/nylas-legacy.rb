# frozen_string_literal: true

require "json"
require "rest-client"

require "ostruct"
require "forwardable"

require_relative "nylas-legacy/version"
require_relative "nylas-legacy/errors"

require_relative "nylas-legacy/logging"
require_relative "nylas-legacy/registry"
require_relative "nylas-legacy/types"
require_relative "nylas-legacy/constraints"

require_relative "nylas-legacy/collection"
require_relative "nylas-legacy/model"

# Attribute types supported by the API
require_relative "nylas-legacy/email_address"
require_relative "nylas-legacy/event"
require_relative "nylas-legacy/event_collection"
require_relative "nylas-legacy/file"
require_relative "nylas-legacy/folder"
require_relative "nylas-legacy/im_address"
require_relative "nylas-legacy/label"
require_relative "nylas-legacy/message_headers"
require_relative "nylas-legacy/message_tracking"
require_relative "nylas-legacy/participant"
require_relative "nylas-legacy/physical_address"
require_relative "nylas-legacy/phone_number"
require_relative "nylas-legacy/recurrence"
require_relative "nylas-legacy/rsvp"
require_relative "nylas-legacy/timespan"
require_relative "nylas-legacy/web_page"
require_relative "nylas-legacy/nylas_date"

# Custom collection types
require_relative "nylas-legacy/search_collection"
require_relative "nylas-legacy/deltas_collection"

# Models supported by the API
require_relative "nylas-legacy/account"
require_relative "nylas-legacy/calendar"
require_relative "nylas-legacy/contact"
require_relative "nylas-legacy/contact_group"
require_relative "nylas-legacy/current_account"
require_relative "nylas-legacy/deltas"
require_relative "nylas-legacy/delta"
require_relative "nylas-legacy/draft"
require_relative "nylas-legacy/message"
require_relative "nylas-legacy/new_message"
require_relative "nylas-legacy/raw_message"
require_relative "nylas-legacy/thread"
require_relative "nylas-legacy/webhook"

require_relative "nylas-legacy/native_authentication"

require_relative "nylas-legacy/http_client"
require_relative "nylas-legacy/api"

# an SDK for interacting with the Nylas API
# @see https://docs.nylas.com/reference
module NylasLegacy
  Types.registry[:account] = Types::ModelType.new(model: Account)
  Types.registry[:calendar] = Types::ModelType.new(model: Calendar)
  Types.registry[:contact] = Types::ModelType.new(model: Contact)
  Types.registry[:delta] = DeltaType.new
  Types.registry[:draft] = Types::ModelType.new(model: Draft)
  Types.registry[:email_address] = Types::ModelType.new(model: EmailAddress)
  Types.registry[:event] = Types::ModelType.new(model: Event)
  Types.registry[:file] = Types::ModelType.new(model: File)
  Types.registry[:folder] = Types::ModelType.new(model: Folder)
  Types.registry[:im_address] = Types::ModelType.new(model: IMAddress)
  Types.registry[:label] = Types::ModelType.new(model: Label)
  Types.registry[:message] = Types::ModelType.new(model: Message)
  Types.registry[:message_headers] = MessageHeadersType.new
  Types.registry[:message_tracking] = Types::ModelType.new(model: MessageTracking)
  Types.registry[:participant] = Types::ModelType.new(model: Participant)
  Types.registry[:physical_address] = Types::ModelType.new(model: PhysicalAddress)
  Types.registry[:phone_number] = Types::ModelType.new(model: PhoneNumber)
  Types.registry[:recurrence] = Types::ModelType.new(model: Recurrence)
  Types.registry[:thread] = Types::ModelType.new(model: Thread)
  Types.registry[:timespan] = Types::ModelType.new(model: Timespan)
  Types.registry[:web_page] = Types::ModelType.new(model: WebPage)
  Types.registry[:nylas_date] = NylasDateType.new
  Types.registry[:contact_group] = Types::ModelType.new(model: ContactGroup)
end
