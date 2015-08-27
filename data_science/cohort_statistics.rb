require 'bigdecimal'

class CohortStatistics
  attr_accessor :converted, :not_con
  INTERVAL = 1.96

  def initialize(cohort_group, cohort_data)
    @cohort_data = cohort_data
    @cohort_group = cohort_group
    cohort_stats
  end

  def cohort_conversion_freq
    @converted = @cohort_data[@cohort_group].count(1).to_f
    @not_con = cohort_size - @converted
    @converted / cohort_size
  end

  def cohort_confidence_interval
    conversion_freq = cohort_conversion_freq
    standard_error = standard_error(conversion_freq, cohort_size)
    bottom_range = conversion_freq - INTERVAL * standard_error
    top_range = conversion_freq + INTERVAL * standard_error
    [bottom_range.round(3), top_range.round(3)]
  end

  def values
    @cohort_group_data = { converted: @converted, not_con: @not_con }
  end

  private

  def cohort_size
    @cohort_data[@cohort_group].length.to_f
  end

  def cohort_stats
    cohort_size
    cohort_conversion_freq
    cohort_confidence_interval
  end

  def standard_error(p, num_trials)
    numerator = p * (1 - p)
    Math.sqrt(numerator / num_trials)
  end
end
