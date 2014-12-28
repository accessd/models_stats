class Seed
  def self.all
    10.times do
      User.create!(name: 'test', created_at: "#{Date.current.year}-#{Date.current.month}-1", type_of: "admin", state: 0)
    end

    4.times do
      User.create!(name: 'test', created_at: "#{Date.current.year}-#{Date.current.month}-3", type_of: "plain", state: 1)
    end

    9.times do
      User.create!(name: 'test', created_at: "#{Date.current.year}-#{Date.current.month}-15", type_of: "plain", state: 0)
    end
  end
end
