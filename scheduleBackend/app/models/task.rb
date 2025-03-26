class Task < ApplicationRecord
    # Validation for required fields
    validates :title, :start_time, :end_time, presence: true
    validates :am_start, :am_end, inclusion: { in: [true, false] }
    validate :validate_days_of_week
  
    # Valid days of the week
    VALID_DAYS = %w[M T W TH F S SU]
  
    # Convert days_of_week to an array when reading from the database
    def days_of_week
      super.split(",") if super.present?
    end
  
    # Convert an array to a comma-separated string when saving to the database
    def days_of_week=(value)
      super(value.join(",")) if value.is_a?(Array)
    end
  
    private
  
    # Custom validation to ensure only valid days are stored
    def validate_days_of_week
      return if days_of_week.blank?
  
      invalid_days = days_of_week - VALID_DAYS
      errors.add(:days_of_week, "contains invalid days: #{invalid_days.join(', ')}") if invalid_days.any?
    end
  end