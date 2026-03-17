# Sends an SMS to the owner whose turn it is when they have a phone number.
# Set TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, and TWILIO_PHONE_NUMBER in the environment.
# Phone numbers should be E.164 format (e.g. +15551234567).
class DraftTurnSms
  def self.send_for_league(league, prev_owner_school)
    new(league, prev_owner_school).send_if_eligible
  end

  def initialize(league, prev_owner_school)
    @league = league
    @prev_owner_school = prev_owner_school
  end

  def body
    [
      "DraftMadness: It's your turn to draft in #{@league.name}!",
      "#{@prev_owner_school.owner.team_name} just drafted #{@prev_owner_school.school.full_name_and_seed}.",
      "#{@league.owner_with_current_turn.team_name} is up."
    ].join("\n")
  end

  def send_if_eligible
    Rails.logger.info "[DraftTurnSms] league=#{@league.name} current_draft_pick=#{@league.current_draft_pick}"

    owner = @league.owner_with_current_turn
    unless owner
      Rails.logger.info "[DraftTurnSms] Skipped: no owner with current turn (draft over?)"
      return
    end

    user = owner.user
    phone = user.phone.to_s.strip
    if phone.blank?
      Rails.logger.info "[DraftTurnSms] Skipped: #{owner.team_name} has no phone number (user_id=#{user.id})"
      return
    end

    unless twilio_configured?
      Rails.logger.warn "[DraftTurnSms] Skipped: Twilio not configured (set TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER)"
      return
    end

    to = normalize_phone(phone)
    msg_body = body
    Rails.logger.info "[DraftTurnSms] Sending to #{to} for #{owner.team_name}: #{msg_body.inspect}"

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to,
      body: msg_body
    )
    Rails.logger.info "[DraftTurnSms] Sent successfully to #{owner.team_name}"
  rescue Twilio::REST::TwilioError => e
    Rails.logger.error "[DraftTurnSms] Twilio error: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.first(5).join("\n")
  end

  private

  def twilio_configured?
    ENV['TWILIO_ACCOUNT_SID'].present? &&
      ENV['TWILIO_AUTH_TOKEN'].present? &&
      ENV['TWILIO_PHONE_NUMBER'].present?
  end

  def client
    @client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end

  # If 10 digits, assume US and add +1. If 11 starting with 1, add +. Otherwise use as-is.
  def normalize_phone(phone)
    digits = phone.gsub(/\D/, '')
    return phone if phone.start_with?('+')
    return "+1#{digits}" if digits.length == 10
    return "+#{digits}" if digits.length == 11 && digits.start_with?('1')
    phone
  end
end
