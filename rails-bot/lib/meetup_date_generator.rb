require 'date'
class MeetupDateGenerator

  def self.days_range(year,month)
    Date.new(year,month,1)..Date.new(year,month,-1)
  end

  def self.generate_dates(year,ordinal,weekday)
    selected = Array.new()
    selected[0] = Array.new
    1.upto(12).each do |month|
      selected[month] = Array((days_range(year,month)).group_by(&:wday)[weekday][ordinal-1])
    end
    selected[1..12].flatten
  end

  def self.next_meetup(year,month,day)
    current_date = Time.new(year,month,day)
    meetups = generate_dates(current_date.year, 3, 4)
    meetup_this_month = meetups[current_date.month-1]
    if meetup_this_month.to_s < "#{current_date.to_s[0..9]}"
      if month == 12
        next_meetup = generate_dates(current_date.year+1, 3, 4)[0]
      else
        next_meetup = meetups[current_date.month]
      end
    else
      next_meetup = meetup_this_month
    end
    next_meetup.to_s
  end

end
