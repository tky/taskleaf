require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'works' do
    task = FactoryBot.create(:task)
    expect(task).to be_valid
  end

  describe 'validation errors' do
    let(:task) { FactoryBot.build(:task, name: name) }
    context 'empty name' do
      let(:name) { '' }
      it { expect(task).not_to be_valid }
    end

    context 'over 30 length' do
      let(:name) { 'n' * 31 }
      it { expect(task).not_to be_valid }
    end

    context 'contains comma' do
      let(:name) { 'a,b' }
      it { expect(task).not_to be_valid }
    end
  end

  describe '#recent' do
    it 'orderd by created at ' do
      FactoryBot.create(:task, id: 1, created_at: Time.new(2019, 2, 15, 0, 0, 0))
      FactoryBot.create(:task, id: 2, created_at: Time.new(2019, 2, 17, 0, 0, 0))
      FactoryBot.create(:task, id: 3, created_at: Time.new(2019, 2, 16, 0, 0, 0))

      expect(Task.recent.map(&:id)).to eq([2, 3, 1])
    end
  end
end
