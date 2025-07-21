class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id" ,dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 50}

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def books_today_count
    books.where(created_at: Time.zone.today.all_day).count
  end

  def books_yesterday_count
    books.where(created_at: 1.day.ago.to_date.all_day).count
  end

  def books_growth_rate_percentage
    today = books_today_count
    yesterday = books_yesterday_count

    return "0%" if today.zero? && yesterday.zero?
    return "∞%" if yesterday.zero? && today.positive?

    rate = (today.to_f / yesterday * 100).round
    "#{rate}%"
  end

  def books_this_week_count
    today = Time.zone.today
    days_since_saturday = (today.wday + 1) % 7
    week_start = today - days_since_saturday.days
    week_end   = week_start + 6.days

    books.where(created_at: week_start.beginning_of_day..week_end.end_of_day).count
  end


  def books_last_week_count
    books.where(created_at: 13.days.ago.beginning_of_day..7.days.ago.end_of_day).count
  end

  # 今週（過去7日間）の投稿数
  def books_past_7_days_count
    books.where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day).count
  end

  # 伸び率（パーセンテージ文字列）
  def books_weekly_growth_rate_percentage
    last_week = books_last_week_count
    this_week = books_past_7_days_count

    if last_week == 0
      return this_week > 0 ? '∞%' : '0%'
    else
      rate = ((this_week - last_week).to_f / last_week * 100).round(1)
      "#{rate}%"
    end
  end
end
