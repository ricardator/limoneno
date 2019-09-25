FactoryBot.define do
  factory :dataset_item do
    name { 'file' }
    dataset_id { 1 }
    mime { 'none' }
    text { 'sample text'}
    url { 'http://'}
    status { 1 }
  end
end