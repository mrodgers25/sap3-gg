# every belongs_to relation that is not required, just add optional: true.
# belongs_to :company, optional: true
Rails.application.config.active_record.belongs_to_required_by_default = true
