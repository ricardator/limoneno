# frozen_string_literal: true

# Dataset Item model
class DatasetItem < ApplicationRecord
  LINE_BREAK_REP = '!LINE_BREAK_REP!'

  enum status: { inactive: 0, active: 1, loading: 2, error: 3 }

  belongs_to :dataset
  has_many :project_dataset_items

  before_save :clean_text, if: :raw_text_changed?

  def clean_text
    self.text = raw_text.gsub(/\n+/, LINE_BREAK_REP).squish
                        .gsub(Regexp.new(" ?#{LINE_BREAK_REP}( #{LINE_BREAK_REP})* ?"), "\n").strip
  end
end
