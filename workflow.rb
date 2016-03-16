class WorkFlow
  attr_accessor :items

  TEMPLATE = '<?xml version="1.0"?><items>%{items}</items>'

  def initialize(items)
    @items = items
    yield(self) if block_given?
  end

  def to_xml
    items_xml = items.map(&:to_xml).join
    TEMPLATE % {items: items_xml}
  end
end

class Item
  attr_accessor :uid, :arg, :valid, :autocomplete, :title, :subtitle, :icon

  TEMPLATE = '<item uid="%{uid}" arg="%{arg}" valid="%{valid}" autocomplete="%{autocomplete}"><title>%{title}</title><subtitle>%{subtitle}</subtitle><icon>%{icon}</icon></item>'

  def initialize(values = {})
    values.each do |key, value|
      self.send("#{key}=", value)
    end if values.is_a? Hash
    yield(self) if block_given?
  end

  def to_xml
    TEMPLATE % {
      uid: uid,
      arg: arg,
      valid: valid,
      autocomplete: autocomplete,
      title: title,
      subtitle: subtitle,
      icon: icon
    }
  end
end
