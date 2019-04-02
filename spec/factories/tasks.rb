FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'テストの準備' }
    user
  end
end
