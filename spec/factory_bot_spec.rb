require 'rails_helper'

RSpec.describe FactoryBot do
  it { FactoryBot.lint traits: true, verbose: true }
end
