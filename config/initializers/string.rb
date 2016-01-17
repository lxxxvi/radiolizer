class String
  def capitalize_all
    self.split(' ').map(&:capitalize).join(' ')
  end
end