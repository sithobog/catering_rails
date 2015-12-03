class DailyMenu < ActiveRecord::Base
  before_save :delete_nils_in_dish_ids

  private

    def  delete_nils_in_dish_ids
      self.dish_ids = self.dish_ids.select { |item| !item.nil? }
    end

end
