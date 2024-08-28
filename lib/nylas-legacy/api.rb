# frozen_string_literal: true

module NylasLegacy
  # Methods to retrieve data from the Nylas API as Ruby objects
  class API
    attr_accessor :client
    extend Forwardable
    def_delegators :client, :execute, :get, :post, :put, :delete, :app_id

    include Logging

    # @param client [HttpClient] Http Client to use for retrieving data
    # @param app_id [String] Your application id from the Nylas Dashboard
    # @param app_secret [String] Your application secret from the Nylas Dashboard
    # @param access_token [String] (Optional) Your users access token.
    # @param api_server [String] (Optional) Which Nylas API Server to connect to. Only change this if
    #                            you're using a self-hosted Nylas instance.
    # @param service_domain [String] (Optional) Host you are authenticating OAuth against.
    # @return [NylasLegacy::API]
    def initialize(client: nil, app_id: nil, app_secret: nil, access_token: nil,
                   api_server: "https://api.nylas.com", service_domain: "api.nylas.com")
      self.client = client || HttpClient.new(app_id: app_id, app_secret: app_secret,
                                             access_token: access_token, api_server: api_server,
                                             service_domain: service_domain)
    end

    # @return [String] A Nylas access token for that particular user.
    def authenticate(name:, email_address:, provider:, settings:, reauth_account_id: nil, scopes: nil)
      NativeAuthentication.new(api: self).authenticate(
        name: name,
        email_address: email_address,
        provider: provider,
        settings: settings,
        reauth_account_id: reauth_account_id,
        scopes: scopes
      )
    end

    # @return [Collection<Contact>] A queryable collection of Contacts
    def contacts
      @contacts ||= Collection.new(model: Contact, api: self)
    end

    # @return [CurrentAccount] The account details for whomevers access token is set
    def current_account
      prevent_calling_if_missing_access_token(:current_account)
      CurrentAccount.from_hash(execute(method: :get, path: "/account"), api: self)
    end

    # @return [Collection<Account>] A queryable collection of {Account}s
    def accounts
      @accounts ||= Collection.new(model: Account, api: as(client.app_secret))
    end

    # @return [Collection<Calendar>] A queryable collection of {Calendar}s
    def calendars
      @calendars ||= Collection.new(model: Calendar, api: self)
    end

    # @return [DeltasCollection<Delta>] A queryable collection of Deltas, which are themselves a collection.
    def deltas
      @deltas ||= DeltasCollection.new(api: self)
    end

    # @return[Collection<Draft>] A queryable collection of {Draft} objects
    def drafts
      @drafts ||= Collection.new(model: Draft, api: self)
    end

    # @return [Collection<Event>] A queryable collection of {Event}s
    def events
      @events ||= EventCollection.new(model: Event, api: self)
    end

    # @return [Collection<Folder>] A queryable collection of {Folder}s
    def folders
      @folders ||= Collection.new(model: Folder, api: self)
    end

    # @return [Collection<File>] A queryable collection of {File}s
    def files
      @files ||= Collection.new(model: File, api: self)
    end

    # @return [Collection<Label>] A queryable collection of {Label} objects
    def labels
      @labels ||= Collection.new(model: Label, api: self)
    end

    # @return[Collection<Message>] A queryable collection of {Message} objects
    def messages
      @messages ||= Collection.new(model: Message, api: self)
    end

    # Revokes access to the Nylas API for the given access token
    # @return [Boolean]
    def revoke(access_token)
      response = client.as(access_token).post(path: "/oauth/revoke")
      response.code == 200 && response.empty?
    end

    # Returns list of IP addresses
    # @return [Hash]
    # hash has keys of :updated_at (unix timestamp) and :ip_addresses (array of strings)
    def ip_addresses
      path = "/a/#{app_id}/ip_addresses"
      client.as(client.app_secret).get(path: path)
    end

    # @param message [Hash, String, #send!]
    # @return [Message] The resulting message
    def send!(message)
      return message.send! if message.respond_to?(:send!)
      return NewMessage.new(**message.merge(api: self)).send! if message.respond_to?(:key?)
      return RawMessage.new(message, api: self).send! if message.is_a? String
    end

    # Allows you to get an API that acts as a different user but otherwise has the same settings
    # @param [String] Oauth Access token or app secret used to authenticate with the API
    # @return [API]
    def as(access_token)
      API.new(client: client.as(access_token))
    end

    # @return [Collection<Thread>] A queryable collection of Threads
    def threads
      @threads ||= Collection.new(model: Thread, api: self)
    end

    # @return [Collection<Webhook>] A queryable collection of {Webhook}s
    def webhooks
      @webhooks ||= Collection.new(model: Webhook, api: as(client.app_secret))
    end

    private

    def prevent_calling_if_missing_access_token(method_name)
      return if client.access_token && !client.access_token.empty?

      raise NoAuthToken, method_name
    end
  end
end
