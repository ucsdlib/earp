# frozen_string_literal: true

# StatisticsController
class StatisticsController < ApplicationController
  include StatisticsHelper
  before_action :require_administrator, only: %i[index]

  # GET /statistics
  def index
    return unless params[:start_date] && params[:end_date]

    start_date = statistics_params[:start_date]
    end_date = statistics_params[:end_date]
    results = Recognition.created_between(start_date, end_date)

    if results.empty?
      flash[:notice] = 'There were no records matching your date range'
    else
      send_data generate_csv(results), filename: "highfive-stats-#{start_date}-#{end_date}.csv"
    end
  end

  private

  def statistics_params
    params.permit(:start_date, :end_date)
  end
end
