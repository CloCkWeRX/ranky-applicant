# frozen_string_literal: true

# A particular competency or area of knowledge well suited to a particular job
#
# Approximately logical model as https://schema.org/skills
class JobSkill < ApplicationRecord
    belongs_to :job
end
