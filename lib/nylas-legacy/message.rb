# frozen_string_literal: true

module NylasLegacy
  # Ruby representatin of a Nylas Message object
  # @see https://docs.nylas.com/reference#messages
  class Message
    include Model
    self.raw_mime_type = "message/rfc822"
    self.resources_path = "/messages"
    allows_operations(showable: true, listable: true, filterable: true, searchable: true, updatable: true)

    attribute :id, :string
    attribute :object, :string
    attribute :account_id, :string
    attribute :thread_id, :string

    attribute :headers, :message_headers

    has_n_of_attribute :to, :email_address
    has_n_of_attribute :from, :email_address
    has_n_of_attribute :cc, :email_address
    has_n_of_attribute :bcc, :email_address
    has_n_of_attribute :reply_to, :email_address

    attribute :date, :unix_timestamp
    # This is only used when receiving a message received notification via a webhook
    attribute :received_date, :unix_timestamp
    attribute :subject, :string
    attribute :snippet, :string
    attribute :body, :string
    attribute :starred, :boolean
    attribute :unread, :boolean

    has_n_of_attribute :events, :event
    has_n_of_attribute :files, :file
    attribute :folder, :folder
    has_n_of_attribute :labels, :label

    def starred?
      starred
    end

    def unread?
      unread
    end

    def expanded
      return self unless headers.nil?

      assign(api.execute(method: :get, path: resource_path, query: { view: "expanded" }))
      self
    end
  end
end
