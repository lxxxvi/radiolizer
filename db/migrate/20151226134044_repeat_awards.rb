class RepeatAwards < ActiveRecord::Migration
  def change
    Award.delete_all

    datetime = Broadcast.all.order(time: :asc).first.time

    while datetime < DateTime.now.beginning_of_week
      Ceremony.prepare( 'week', datetime ).perform
      datetime = datetime.next_week
    end
  end
end
