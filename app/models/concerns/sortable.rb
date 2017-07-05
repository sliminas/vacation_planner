module Sortable

  extend ActiveSupport::Concern

  SORT_DIR = {
    'asc' => :asc,
    'desc' => :desc,
  }

  SORT_BY = {
    employee: {
      'name' => :name
    },
    vacation_request: {
      'start_date' => :start_date,
      'end_date' => :end_date,
      'state' => :state
    }
  }

  included do

    scope :order_by, ->(params) {
      by = SORT_BY[search_class][params[:sort]] || :id
      dir = SORT_DIR[params[:sort_dir]] || :asc
      order(by => dir)
    }

  end

  module ClassMethods

    def search_class
      self.name.underscore.to_sym
    end

  end

end
