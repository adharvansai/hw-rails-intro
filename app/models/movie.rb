class Movie < ActiveRecord::Base
  def self.all_ratings
    select(:rating).map(&:rating).uniq
  end
  
  def self.with_ratings(ratings)
    if ratings.nil? #no rating is selected
      Movie.all
    else #filetering by a particular rating
      Movie.where(rating:ratings)
    end
  end
end