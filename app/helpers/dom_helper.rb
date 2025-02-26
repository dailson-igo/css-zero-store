module DomHelper
  def custom_dom_id(record, prefix = nil)
    model_name = record.class.name.underscore.tr("/", "_") # Admin::Customer → admin_customer
    [
      prefix,
      model_name,
      record.sqid
    ].compact.join("_")
  end
end
