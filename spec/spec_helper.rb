# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "nylas-legacy"
require "pry"
require "webmock/rspec"
require "rspec-json_matcher"

RSpec.configuration.include RSpec::JsonMatcher

class FakeAPI
  def execute(method:, path:, payload: nil)
    requests.push(method: method, path: path, payload: payload)
  end

  def requests
    @requests ||= []
  end
end

# Illustrates all the types and such a model can be built out of. Used for testing the generic Model
# functionality without conflating it with actual Models
class FullModel
  include NylasLegacy::Model
  self.creatable = true
  self.showable = true
  self.listable = true
  self.filterable = true
  self.updatable = true
  self.destroyable = true

  self.resources_path = "/collection"

  attribute :id, :string

  attribute :date, :date
  attribute :email_address, :email_address
  attribute :im_address, :im_address
  attribute :nylas_date, :nylas_date
  attribute :phone_number, :phone_number
  attribute :physical_address, :physical_address
  attribute :string, :string
  attribute :web_page, :web_page

  has_n_of_attribute :web_pages, :web_page
end

class NotCreatableModel
  include NylasLegacy::Model
  self.resources_path = "/not_creatable_collection"

  attribute :id, :string

  attribute :date, :date
  attribute :email_address, :email_address
  attribute :im_address, :im_address
  attribute :nylas_date, :nylas_date
  attribute :phone_number, :phone_number
  attribute :physical_address, :physical_address
  attribute :string, :string
  attribute :web_page, :web_page

  has_n_of_attribute :web_pages, :web_page
end

class NotUpdatableModel
  include NylasLegacy::Model
  self.resources_path = "/not_updatable_collection"

  attribute :id, :string

  attribute :date, :date
  attribute :email_address, :email_address
  attribute :im_address, :im_address
  attribute :nylas_date, :nylas_date
  attribute :phone_number, :phone_number
  attribute :physical_address, :physical_address
  attribute :string, :string
  attribute :web_page, :web_page

  has_n_of_attribute :web_pages, :web_page
end

class NonFilterableModel < FullModel
  include NylasLegacy::Model
  self.resources_path = "/non_filterable_collection"

  attribute :id, :string

  attribute :date, :date
  attribute :email_address, :email_address
  attribute :im_address, :im_address
  attribute :nylas_date, :nylas_date
  attribute :phone_number, :phone_number
  attribute :physical_address, :physical_address
  attribute :string, :string
  attribute :web_page, :web_page

  has_n_of_attribute :web_pages, :web_page
end
