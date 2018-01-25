class TeamQuery
  attr_reader :teams, :options

  def initialize(teams = Team.all, options = {})
    @teams = teams
    @options = options
  end

  def user_teams
    filter_by_contest
    filter_by_owner
  end

  def approved_affiliates_teams
    filter_by_contest
    filter_by_not_owner.where(status: Team::APPROVED)
  end

  def waiting_affiliates_teams
    filter_by_contest
    filter_by_not_owner.where(status: Team::WAITING)
  end

  private

  def filter_by_contest
    @teams = teams.where(contest_id: options[:contest_id])
  end

  def filter_by_owner
    teams.where(owner_id: options[:current_user].id)
  end

  def filter_by_not_owner
    teams.where.not(owner_id: options[:current_user].id)
  end
end
