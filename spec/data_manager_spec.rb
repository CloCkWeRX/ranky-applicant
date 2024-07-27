# frozen_string_literal: true

require './spec/rails_helper'

describe Ranker::DataManager do
  describe '#purge!' do
    it 'removes all existing data'
  end

  describe '#load!' do
    context 'with valid data' do
      it 'populates the data'
    end

    context 'wtih bad data' do
      it 'raises an IOError'
    end
  end
end
