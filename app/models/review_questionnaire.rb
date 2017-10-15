class ReviewQuestionnaire < Questionnaire
  after_initialize :post_initialization
  def post_initialization
    self.display_type = 'Review'
  end

  def symbol
    "review".to_sym
  end

  def get_assessments_for(participant)
    participant.reviews
  end

  # return  the responses for specified round, for varying rubric feature -Yang
  def get_assessments_round_for(participant, round)
    team = AssignmentTeam.team(participant)
    return nil unless team

    team_id = team.id
    responses = []
    if participant
      maps = ResponseMap.where(reviewee_id: team_id, type: "ReviewResponseMap")
      # puts("Maps +++++++")
      # puts(maps)
      puts "maps response"
      maps.each do |map|
        next if map.response.empty?
        # puts map.response.inspect
        puts map.response.round
        map.response.each do |response|
          if response.round == round && response.is_submitted
            responses << response
          end
        end
      end
      # responses = Response.find(:all, :include => :map, :conditions => ['reviewee_id = ? and type = ?',participant.id, self.to_s])
      responses.sort! {|a, b| a.map.reviewer.fullname <=> b.map.reviewer.fullname }
    end
    responses
  end
end
