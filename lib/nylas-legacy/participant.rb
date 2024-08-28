# frozen_string_literal: true

module NylasLegacy
  # Structure to represent the Participant
  class Participant
    include Model::Attributable
    attribute :name, :string
    attribute :email, :string
    attribute :comment, :string
    attribute :status, :string
  end
end
